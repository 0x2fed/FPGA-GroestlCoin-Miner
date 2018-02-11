

module serial_receive(clk, RxD, is_last, data, nonce, target0, target1);
   input      clk;
   input      RxD;

   output [607:0] data;     
   output [31:0]  nonce;    
   output [31:0]  target0;    
   output [31:0]  target1;  
   output is_last;  

   
   wire       RxD_data_ready;
   wire [7:0] RxD_data;   

   reg [703:0] input_buffer;

   reg is_last_reg = 1'b0;
   
   reg [6:0]   demux_state = 7'b0000000;//reg [5:0]   demux_state = 6'b000000; //   reg [6:0]   demux_state = 7'b0000000;   

   
   assign data   	= input_buffer[703:96];           
   assign nonce  	= input_buffer[95:64];  
   assign target0 	= input_buffer[63:32]; 
   assign target1  	= input_buffer[31:0]; 
   
   
   assign is_last = is_last_reg;   
   
	parameter SERIAL_TIMEOUT = 24'h800000;   
   reg [23:0]  timer = 0;       
   
   
 // async_receiver deserializer(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));   
    uart_receiver urx (.clk(clk), .uart_rx(RxD), .tx_new_byte(RxD_data_ready), .tx_byte(RxD_data));        

   
   // we probably don't need a busy signal here, just read the latest
   // complete input that is available.
   
   always @(posedge clk)
     case (demux_state)
 //   7'b1101100://864
//	  7'b1101000://832
	  7'b1011000://704
//	  7'b1010000://640
//	  7'b1001100://608
//	  7'b1001000://576 // END Message input
	 begin
	//    input_copy <= input_buffer;
	    demux_state <= 0;
		is_last_reg <= 1;		
	 end
       
       default:
	   begin
		is_last_reg <= 0;	
		
		if(RxD_data_ready)
		begin
	      input_buffer <= input_buffer << 8;
	      input_buffer[7:0] <= RxD_data;
	      demux_state <= demux_state + 7'b0000001;
		end else
	   	      begin
	         timer <= timer + 1;
	         if (timer == SERIAL_TIMEOUT)
	           demux_state <= 0;
	      end
		end  //default
     endcase // case (demux_state)
   
endmodule // serial_receive

module serial_transmit (clk, TxD, busy, send, word);
   
   // split 4-byte output into bytes

   wire TxD_start;
   wire TxD_ready;
   
   reg [7:0]  out_byte;
   reg        serial_start;
   reg [3:0]  mux_state = 4'b0000;

   assign TxD_start = serial_start;

   input      clk;
   output     TxD;
   
   input [31:0] word;
   input 	send;
   output 	busy;

   reg [31:0] 	word_copy;
   
   assign busy = (|mux_state);

   always @(posedge clk)
     begin

	// Testing for busy is problematic if we are keeping the
	// module busy all the time :-/ So we need some wait stages
	// between the bytes.

	if (!busy && send)
	  begin
	     mux_state <= 4'b1000;
	     word_copy <= word;
	  end  

	else if (mux_state[3] && ~mux_state[0] && TxD_ready)
	  begin
	     serial_start <= 1;
	     mux_state <= mux_state + 4'b0001;

	     out_byte <= word_copy[31:24];
	     word_copy <= (word_copy << 8);
	  end
	
	// wait stages
	else if (mux_state[3] && mux_state[0])
	  begin
	     serial_start <= 0;
	     if (TxD_ready) mux_state <= mux_state + 4'b0001;
	  end
     end

//   async_transmitter serializer(.clk(clk), .TxD_start(TxD_start), .TxD_data(out_byte), .TxD(TxD), .TxD_busy(TxD_busy));
    uart_transmitter utx (.clk(clk), .uart_tx(TxD), .rx_new_byte(TxD_start), .rx_byte(out_byte), .tx_ready(TxD_ready));
endmodule // serial_send
