
//`define SIM



module groestlminer(

    input wire  osc_clk,
  	input 		RxD,
	output 	   	TxD,
	output      [3:0] led	  
     );

	  
	//// Clocking	  
	wire clk;
	
	`ifdef SIM
		assign clk = osc_clk;		
	`else
//		assign clk = osc_clk;	
		main_pll pll_blk ( .inclk0(osc_clk), .c0(clk) );
		// c0 - 20mhz
		// c1 - 40mhz
		// c2 - 60mhz
		// c3 - 80mhz
	`endif	
		
	
		
assign led[3:0] = nonce_out[23:20];

		
	//// Virtual Wire Control
	wire	[607:0] 	data_vw;
	wire	[31:0] 		nonce_vw;
	wire	[31:0] 		target_vw0;	
	wire	[31:0] 		target_vw1;		
	
	wire	last_recv_vw;

	
	//// Virtual Wire Output
	reg 		serial_send = 0;
	wire 	  	serial_busy;	

	wire		out_ready;	
	
   reg rst = 1;	
   
//	reg [639:0] 	data = 0;	

	wire [31:0] nonce_out;
	reg  [31:0] golden_nonce;
	reg [31:0]  target0;
	reg [31:0]  target1;	
	
	serial_receive serrx (.clk(clk), .RxD(RxD), .is_last(last_recv_vw), .data(data_vw), .nonce(nonce_vw), .target0(target_vw0), .target1(target_vw1));
	serial_transmit sertx (.clk(clk), .TxD(TxD), .send(serial_send), .busy(serial_busy), .word(golden_nonce));	
	
	
    grostl_512 uut (
        .msg(data_vw),
        .nonce_in(nonce_vw),	
        .nonce_out(nonce_out),	 	
        .out_ready(out_ready),
        .clk(clk),
        .rst(rst),
		.target0(target0), 
		.target1(target1)
    );	
	

	//// Control Unit
	reg [6:0]   state = 0;			

	always @(posedge clk)
	begin

		if (last_recv_vw) begin			//golden_nonce <= data2_vw[255:224];//golden_nonce_next;	
			target0 <= target_vw0;	
			target1 <= target_vw1;	
			rst <= 1;		
			state <= 1;					
		end 	
			
			
	case (state)
      0:    // 
	 begin
		serial_send <= 0;	
		rst <= 1;
	 end	
      1:    // RESET-OFF START-ON COPY-DATA FROM SERIAL PORT
	 begin
		rst <= 0;		 	
		state <= 2;				
	 end
      64:    // LOad data
	 begin	 

		if (out_ready)//( | (nonce_out==32'h7fffffff)) 
				begin
				golden_nonce <= nonce_out;
				serial_send <= 1;
				state <= 0;	
				rst <= 1;				
				end		
	 end //11	 
	    			   
   
	 default:
		begin
		state <= state + 7'b0000001;
	 end		
			 
	 
	 
	 
     endcase // case 
			
     end //always

	 


endmodule

