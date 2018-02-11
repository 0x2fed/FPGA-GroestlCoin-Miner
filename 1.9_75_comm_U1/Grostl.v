`define high_pos(x,y)       1023 - (128*x+8*y)
`define low_pos(x,y)        `high_pos(x,y) - 7
`define high_pos2(x,y)       1023 - (64*x+8*y)
`define low_pos2(x,y)        `high_pos2(x,y) - 7


module grostl_512
  (msg, nonce_in, nonce_out, out_ready, clk, rst, target0, target1);

   //------------------------------------------------
   input  [607:0] msg;       // Message  
   input  [31:0]  nonce_in;  //   
   input  [31:0]  	target0; 
   input  [31:0]  	target1; 
   output [31:0]  nonce_out; //    
   output         out_ready; // Busy
   input          clk, rst;  // Clock and reset
   //------------------------------------------------
   	
  
   reg [1023:0]    p_11, q_11, p_12;
   reg [1023:0]    p_21, q_21, p_22;
   
   wire [1023:0]   dinP_11, dinP_12;
   wire [1023:0]   dinP_21, dinP_22;   
   
   wire [1023:0]   pin_11, pout_11;
   wire [1023:0]   qin_11, qout_11;   
   wire [1023:0]   pin_12, pout_12;   
   
   wire [1023:0]   pin_21, pout_21;
   wire [1023:0]   qin_21, qout_21;   
   wire [1023:0]   pin_22, pout_22;  
   
  	reg [31:0] 		nonce;  
   
   wire [1023:0]  in_vw1;//chaining;   
   wire [1023:0]  in_vw2;//chaining;   
   wire [1023:0]  temp1;   
   wire [1023:0]  temp2;   
   genvar i, j; 

 reg [1023:0]    h1,h3;  
 wire [511:0]   p1,q1;      
 
 wire [1023:0]   h2,h4;  
 wire [511:0]    msg2;
 
 	wire [511:0] out1;
	wire [255:0] out2,hash;
	
   //------------------------------------------------	
   
   reg [3:0]      round; 

	reg ready = 1'b0;	
	
	
	
    assign in_vw1 = {msg[607:0],nonce,384'h800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001};  
    assign in_vw2 = {msg2,512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001};

   
	index_relocation_in  index_relocation_in1 (.in(in_vw1), .out(temp1));   
	index_relocation_in  index_relocation_in2 (.in(in_vw2), .out(temp2));  
   
   
	assign h2 = h1 ^ p_12;   
	assign h4 = h3 ^ p_22;  
	
    assign msg2 = {h2[959:952],h2[831:824],h2[703:696],h2[575:568],h2[447:440],h2[319:312],h2[191:184],h2[63:56],
				 h2[951:944],h2[823:816],h2[695:688],h2[567:560],h2[439:432],h2[311:304],h2[183:176],h2[55:48],
				 h2[943:936],h2[815:808],h2[687:680],h2[559:552],h2[431:424],h2[303:296],h2[175:168],h2[47:40],
				 h2[935:928],h2[807:800],h2[679:672],h2[551:544],h2[423:416],h2[295:288],h2[167:160],h2[39:32],
				 h2[927:920],h2[799:792],h2[671:664],h2[543:536],h2[415:408],h2[287:280],h2[159:152],h2[31:24],
				 h2[919:912],h2[791:784],h2[663:656],h2[535:528],h2[407:400],h2[279:272],h2[151:144],h2[23:16],
				 h2[911:904],h2[783:776],h2[655:648],h2[527:520],h2[399:392],h2[271:264],h2[143:136],h2[15:8],
				 h2[903:896],h2[775:768],h2[647:640],h2[519:512],h2[391:384],h2[263:256],h2[135:128],h2[7:0]};    
				 
    assign out1 = {h4[959:952],h4[831:824],h4[703:696],h4[575:568],h4[447:440],h4[319:312],h4[191:184],h4[63:56],
				 h4[951:944],h4[823:816],h4[695:688],h4[567:560],h4[439:432],h4[311:304],h4[183:176],h4[55:48],
				 h4[943:936],h4[815:808],h4[687:680],h4[559:552],h4[431:424],h4[303:296],h4[175:168],h4[47:40],
				 h4[935:928],h4[807:800],h4[679:672],h4[551:544],h4[423:416],h4[295:288],h4[167:160],h4[39:32],
				 h4[927:920],h4[799:792],h4[671:664],h4[543:536],h4[415:408],h4[287:280],h4[159:152],h4[31:24],
				 h4[919:912],h4[791:784],h4[663:656],h4[535:528],h4[407:400],h4[279:272],h4[151:144],h4[23:16],
				 h4[911:904],h4[783:776],h4[655:648],h4[527:520],h4[399:392],h4[271:264],h4[143:136],h4[15:8],
				 h4[903:896],h4[775:768],h4[647:640],h4[519:512],h4[391:384],h4[263:256],h4[135:128],h4[7:0]};       
				
				
	assign out2 = out1[511:256];	

	reverce reverce(.in(out2),.out(hash));
	
    //------------------------------------------------ Hash path
    always @ (posedge clk)
     if (rst)            h1 <= 1024'h0;
     else if (round==4'hE) h1 <= dinP_12;	 
	 
    always @ (posedge clk)
     if (rst)              h3 <= 1024'h0;
     else if (round==4'hE) h3 <= dinP_22;
   
   

   assign dinP_11 = {temp1[1023:136], temp1[135:128]^8'h02 ,temp1[127:0]};//
   assign dinP_12 = {p_11[1023:136], p_11[135:128]^8'h02 ,p_11[127:0]} ^ q_11 ;   
   
   // P11
   assign pin_11 = p_11;   
   perm_P perm_P_11 (.x(pin_11), .y(pout_11), .round(round));
	 
   // Q11
   assign qin_11 = q_11;
   perm_Q perm_Q_11 (.x(qin_11), .y(qout_11), .round(round));
   
   // P12
   assign pin_12 = p_12;   
   perm_P perm_P_12 (.x(pin_12), .y(pout_12), .round(round));
   
   
   
   assign dinP_21 = {temp2[1023:136], temp2[135:128]^8'h02 ,temp2[127:0]};
   assign dinP_22 = {p_21[1023:136], p_21[135:128]^8'h02 ,p_21[127:0]} ^ q_21 ;    
  
   // P21
   assign pin_21 = p_21;   
   perm_P perm_P_21 (.x(pin_21), .y(pout_21), .round(round));   
	 
   // Q21
   assign qin_21 = q_21;
   perm_Q perm_Q_21 (.x(qin_21), .y(qout_21), .round(round));    
   
   // P22
   assign pin_22 = p_22;   
   perm_P perm_P_22 (.x(pin_22), .y(pout_22), .round(round));    
 /*  */ 
   
 
   
	always @ (posedge clk)
     if (rst)                        q_11 <= 1024'h0;
     else if (round==4'hE)             q_11 <= temp1;// OR
     else 							   q_11 <= qout_11;  
  
	always @ (posedge clk)
     if (rst)                        p_11 <= 1024'h0;
     else if (round==4'hE)             p_11 <= dinP_11;// OR
     else       					   p_11 <= pout_11;  

    always @ (posedge clk)
     if (rst)                        p_12 <= 1024'h0;
     else if (round==4'hE)             p_12 <= dinP_12;  
     else 							   p_12 <= pout_12; 

    always @ (posedge clk)
     if (rst)                        q_21 <= 1024'h0;
     else if (round==4'hE)             q_21 <= temp2;
     else 							   q_21 <= qout_21;  
   
    always @ (posedge clk)
     if (rst)                        p_21 <= 1024'h0;
     else if (round==4'hE)             p_21 <= dinP_21;  
     else       					   p_21 <= pout_21;  

    always @ (posedge clk)
     if (rst)                        p_22 <= 1024'h0;
     else if (round==4'hE)             p_22 <= dinP_22;  
     else 							   p_22 <= pout_22; 

	 
   //------------------------------------------------ Controller
    always @ (posedge clk)
     if (rst)                            	round <= 4'hE;
     else if (round == 4'hE)  				round <= 4'h0;
     else 					                round <= round + 4'h1;
   

    always @ (posedge clk)
     if (rst)  
		ready <= 0;
	 else
		ready <= ((round==4'hE)&(hash[255:224] <= target0)&(hash[223:192] <= target1));
 
	 
	 assign out_ready =	ready;   
   
   
    always @ (posedge clk)
     if (rst)              nonce <= nonce_in + 32'h80000000;//32'h003d3d90;
     else if (round==4'hE) nonce <= nonce + 1;      
   
   assign nonce_out = nonce;    
   

endmodule // GROSTL_512


module reverce(in, out);
	input  [255:0] in;
	output [255:0] out;
	
genvar i; 

    generate
          for(i=0; i<32; i=i+1)
            begin : L3
				assign out[(255 - (8*i)):(255 - (8*i)-7)] = in[(8*i)+7:(8*i)];				
            end
    endgenerate  

endmodule // index_relocation_out

module index_relocation_in(in, out);
  input  [1023:0] in;
  output [1023:0] out;
    genvar i, j;
	
    generate
      for(i=0; i<8; i=i+1)
        begin : L2
          for(j=0; j<16; j=j+1)
            begin : L3
				assign out[`high_pos(i,j):`low_pos(i,j)] = in[`high_pos2(j,i):`low_pos2(j,i)];				
            end
        end
    endgenerate  
  
 endmodule // index_relocation_in

module AddRoundConstant(in, out, round);
	input  [127:0] in;
	output [127:0] out;
	input [3:0]    round; // Round

	assign out 	= {	in[127:120]^{4'h0,round},
					in[119:112]^{4'h1,round},
					in[111:104]^{4'h2,round},
					in[103:96] ^{4'h3,round},
					in[95:88]  ^{4'h4,round},
					in[87:80]  ^{4'h5,round},
					in[79:72]  ^{4'h6,round},
					in[71:64]  ^{4'h7,round},
					in[63:56]  ^{4'h8,round},
					in[55:48]  ^{4'h9,round},
					in[47:40]  ^{4'ha,round},
					in[39:32]  ^{4'hb,round},
					in[31:24]  ^{4'hc,round},
					in[23:16]  ^{4'hd,round},
					in[15:8]   ^{4'he,round},
					in[7:0]    ^{4'hf,round}	};	

endmodule // index_relocation_out


module SubBytes(in, out);
	input  [1023:0] in;
	output [1023:0] out;
  
    genvar i, j;
	
	wire [7:0]     x[7:0][15:0];	
	wire [7:0]     y[7:0][15:0];

	
    generate
      for(i=0; i<8; i=i+1)
        begin : L0
          for(j=0; j<16; j=j+1)
            begin : L1
			
				assign x[i][j] = in[`high_pos(i,j):`low_pos(i,j)];				
				SubBytes_Composite Sbox00(.x(x[i][j]), .y(y[i][j]));
				//SBOX Sbox00(.x(x[i][j]), .y(y[i][j]));				
				assign out[`high_pos(i,j):`low_pos(i,j)] = y[i][j];
				
            end
        end
    endgenerate   
endmodule




`undef low_pos
`undef low_pos2
`undef high_pos
`undef high_pos2





//================================================ perm_P
module perm_P (x, y, round);

   //------------------------------------------------
   input [1023:0]  x;     // Input message
   output [1023:0] y;     // Output
   input [3:0]    round; // Round

   //------------------------------------------------
   wire [127:0] 	in_add;
   wire [127:0] 	out_add;
   
   wire [1023:0]  x0;     
   wire [1023:0]  x2;
   wire [1023:0]  x3;
   wire [1023:0]  x4;
   wire [1023:0]  x5;
   //------------------------------------------------
   //---------------- AddRoundConstant
   
    assign x0 = x;
    
	assign in_add = {x0[1023:1023-127]};
     
	AddRoundConstant  
		AddRoundConstant (in_add, out_add, round);   
  
	assign x2 = {out_add,x[1023-128:0]};
	   
   //---------------- SubBytes
	SubBytes  
		SubBytes (.in(x2), .out(x3));  	
	//---------------- ShiftBytes	

assign x4 ={x3[1023:896],
			x3[887:768],x3[895:888],
			x3[751:640],x3[767:752],
			x3[615:512],x3[639:616],
			x3[479:384],x3[511:480],
			x3[343:256],x3[383:344],
			x3[207:128],x3[255:208],
			x3[39:0],x3[127:40]};

		
	//---------------- MixBytes
	MixBytes
		MixBytes (.in(x4), .out(x5)); 	
		
	assign y = x5;		
      
endmodule // perm_P



//================================================ perm_Q
module perm_Q (x, y, round);

   //------------------------------------------------
   input [1023:0]  x;     // Input message
   output [1023:0] y;     // Output
   input [3:0]    round; // Round

   //------------------------------------------------
   wire [127:0] 	in_add;
   wire [127:0] 	out_add;
   
   wire [1023:0]  x0;     
   wire [1023:0]  x2;
   wire [1023:0]  x3;
   wire [1023:0]  x4;
   wire [1023:0]  x5;
   //------------------------------------------------
   //---------------- AddRoundConstant
   
    assign x0 = x^1024'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
	assign in_add = {x0[127:0]};
     
	AddRoundConstant  
		AddRoundConstant (in_add, out_add, round);   
  
	assign x2 = {x0[1023:128],out_add};
	   
   //---------------- SubBytes
	SubBytes  
		SubBytes (.in(x2), .out(x3));  	
	//---------------- ShiftBytes	

	assign x4 = {x3[1015:896],x3[1023:1016],
			x3[871:768],x3[895:872],
			x3[727:640],x3[767:728],
			x3[551:512],x3[639:552],
			x3[511:384],
			x3[367:256],x3[383:368],
			x3[223:128],x3[255:224],
			x3[79:0],x3[127:80]};


	//---------------- MixBytes
	MixBytes
		MixBytes (.in(x4), .out(x5)); 	
		
	assign y = x5;		
      
endmodule // perm_Q

//================================================ SubBytes_Composite

module SubBytes_Composite (x, y);
   input  [7:0] x;
   output [7:0] y;

     reg [7:0] o;
    always @(x) begin
      case (x)
        8'h00: o = 8'h63;    8'h01: o = 8'h7c;    8'h02: o = 8'h77;    8'h03: o = 8'h7b;
        8'h04: o = 8'hf2;    8'h05: o = 8'h6b;    8'h06: o = 8'h6f;    8'h07: o = 8'hc5;
        8'h08: o = 8'h30;    8'h09: o = 8'h01;    8'h0a: o = 8'h67;    8'h0b: o = 8'h2b;
        8'h0c: o = 8'hfe;    8'h0d: o = 8'hd7;    8'h0e: o = 8'hab;    8'h0f: o = 8'h76;
        8'h10: o = 8'hca;    8'h11: o = 8'h82;    8'h12: o = 8'hc9;    8'h13: o = 8'h7d;
        8'h14: o = 8'hfa;    8'h15: o = 8'h59;    8'h16: o = 8'h47;    8'h17: o = 8'hf0;
        8'h18: o = 8'had;    8'h19: o = 8'hd4;    8'h1a: o = 8'ha2;    8'h1b: o = 8'haf;
        8'h1c: o = 8'h9c;    8'h1d: o = 8'ha4;    8'h1e: o = 8'h72;    8'h1f: o = 8'hc0;
        8'h20: o = 8'hb7;    8'h21: o = 8'hfd;    8'h22: o = 8'h93;    8'h23: o = 8'h26;
        8'h24: o = 8'h36;    8'h25: o = 8'h3f;    8'h26: o = 8'hf7;    8'h27: o = 8'hcc;
        8'h28: o = 8'h34;    8'h29: o = 8'ha5;    8'h2a: o = 8'he5;    8'h2b: o = 8'hf1;
        8'h2c: o = 8'h71;    8'h2d: o = 8'hd8;    8'h2e: o = 8'h31;    8'h2f: o = 8'h15;
        8'h30: o = 8'h04;    8'h31: o = 8'hc7;    8'h32: o = 8'h23;    8'h33: o = 8'hc3;
        8'h34: o = 8'h18;    8'h35: o = 8'h96;    8'h36: o = 8'h05;    8'h37: o = 8'h9a;
        8'h38: o = 8'h07;    8'h39: o = 8'h12;    8'h3a: o = 8'h80;    8'h3b: o = 8'he2;
        8'h3c: o = 8'heb;    8'h3d: o = 8'h27;    8'h3e: o = 8'hb2;    8'h3f: o = 8'h75;
        8'h40: o = 8'h09;    8'h41: o = 8'h83;    8'h42: o = 8'h2c;    8'h43: o = 8'h1a;
        8'h44: o = 8'h1b;    8'h45: o = 8'h6e;    8'h46: o = 8'h5a;    8'h47: o = 8'ha0;
        8'h48: o = 8'h52;    8'h49: o = 8'h3b;    8'h4a: o = 8'hd6;    8'h4b: o = 8'hb3;
        8'h4c: o = 8'h29;    8'h4d: o = 8'he3;    8'h4e: o = 8'h2f;    8'h4f: o = 8'h84;
        8'h50: o = 8'h53;    8'h51: o = 8'hd1;    8'h52: o = 8'h00;    8'h53: o = 8'hed;
        8'h54: o = 8'h20;    8'h55: o = 8'hfc;    8'h56: o = 8'hb1;    8'h57: o = 8'h5b;
        8'h58: o = 8'h6a;    8'h59: o = 8'hcb;    8'h5a: o = 8'hbe;    8'h5b: o = 8'h39;
        8'h5c: o = 8'h4a;    8'h5d: o = 8'h4c;    8'h5e: o = 8'h58;    8'h5f: o = 8'hcf;
        8'h60: o = 8'hd0;    8'h61: o = 8'hef;    8'h62: o = 8'haa;    8'h63: o = 8'hfb;
        8'h64: o = 8'h43;    8'h65: o = 8'h4d;    8'h66: o = 8'h33;    8'h67: o = 8'h85;
        8'h68: o = 8'h45;    8'h69: o = 8'hf9;    8'h6a: o = 8'h02;    8'h6b: o = 8'h7f;
        8'h6c: o = 8'h50;    8'h6d: o = 8'h3c;    8'h6e: o = 8'h9f;    8'h6f: o = 8'ha8;
        8'h70: o = 8'h51;    8'h71: o = 8'ha3;    8'h72: o = 8'h40;    8'h73: o = 8'h8f;
        8'h74: o = 8'h92;    8'h75: o = 8'h9d;    8'h76: o = 8'h38;    8'h77: o = 8'hf5;
        8'h78: o = 8'hbc;    8'h79: o = 8'hb6;    8'h7a: o = 8'hda;    8'h7b: o = 8'h21;
        8'h7c: o = 8'h10;    8'h7d: o = 8'hff;    8'h7e: o = 8'hf3;    8'h7f: o = 8'hd2;
        8'h80: o = 8'hcd;    8'h81: o = 8'h0c;    8'h82: o = 8'h13;    8'h83: o = 8'hec;
        8'h84: o = 8'h5f;    8'h85: o = 8'h97;    8'h86: o = 8'h44;    8'h87: o = 8'h17;
        8'h88: o = 8'hc4;    8'h89: o = 8'ha7;    8'h8a: o = 8'h7e;    8'h8b: o = 8'h3d;
        8'h8c: o = 8'h64;    8'h8d: o = 8'h5d;    8'h8e: o = 8'h19;    8'h8f: o = 8'h73;
        8'h90: o = 8'h60;    8'h91: o = 8'h81;    8'h92: o = 8'h4f;    8'h93: o = 8'hdc;
        8'h94: o = 8'h22;    8'h95: o = 8'h2a;    8'h96: o = 8'h90;    8'h97: o = 8'h88;
        8'h98: o = 8'h46;    8'h99: o = 8'hee;    8'h9a: o = 8'hb8;    8'h9b: o = 8'h14;
        8'h9c: o = 8'hde;    8'h9d: o = 8'h5e;    8'h9e: o = 8'h0b;    8'h9f: o = 8'hdb;
        8'ha0: o = 8'he0;    8'ha1: o = 8'h32;    8'ha2: o = 8'h3a;    8'ha3: o = 8'h0a;
        8'ha4: o = 8'h49;    8'ha5: o = 8'h06;    8'ha6: o = 8'h24;    8'ha7: o = 8'h5c;
        8'ha8: o = 8'hc2;    8'ha9: o = 8'hd3;    8'haa: o = 8'hac;    8'hab: o = 8'h62;
        8'hac: o = 8'h91;    8'had: o = 8'h95;    8'hae: o = 8'he4;    8'haf: o = 8'h79;
        8'hb0: o = 8'he7;    8'hb1: o = 8'hc8;    8'hb2: o = 8'h37;    8'hb3: o = 8'h6d;
        8'hb4: o = 8'h8d;    8'hb5: o = 8'hd5;    8'hb6: o = 8'h4e;    8'hb7: o = 8'ha9;
        8'hb8: o = 8'h6c;    8'hb9: o = 8'h56;    8'hba: o = 8'hf4;    8'hbb: o = 8'hea;
        8'hbc: o = 8'h65;    8'hbd: o = 8'h7a;    8'hbe: o = 8'hae;    8'hbf: o = 8'h08;
        8'hc0: o = 8'hba;    8'hc1: o = 8'h78;    8'hc2: o = 8'h25;    8'hc3: o = 8'h2e;
        8'hc4: o = 8'h1c;    8'hc5: o = 8'ha6;    8'hc6: o = 8'hb4;    8'hc7: o = 8'hc6;
        8'hc8: o = 8'he8;    8'hc9: o = 8'hdd;    8'hca: o = 8'h74;    8'hcb: o = 8'h1f;
        8'hcc: o = 8'h4b;    8'hcd: o = 8'hbd;    8'hce: o = 8'h8b;    8'hcf: o = 8'h8a;
        8'hd0: o = 8'h70;    8'hd1: o = 8'h3e;    8'hd2: o = 8'hb5;    8'hd3: o = 8'h66;
        8'hd4: o = 8'h48;    8'hd5: o = 8'h03;    8'hd6: o = 8'hf6;    8'hd7: o = 8'h0e;
        8'hd8: o = 8'h61;    8'hd9: o = 8'h35;    8'hda: o = 8'h57;    8'hdb: o = 8'hb9;
        8'hdc: o = 8'h86;    8'hdd: o = 8'hc1;    8'hde: o = 8'h1d;    8'hdf: o = 8'h9e;
        8'he0: o = 8'he1;    8'he1: o = 8'hf8;    8'he2: o = 8'h98;    8'he3: o = 8'h11;
        8'he4: o = 8'h69;    8'he5: o = 8'hd9;    8'he6: o = 8'h8e;    8'he7: o = 8'h94;
        8'he8: o = 8'h9b;    8'he9: o = 8'h1e;    8'hea: o = 8'h87;    8'heb: o = 8'he9;
        8'hec: o = 8'hce;    8'hed: o = 8'h55;    8'hee: o = 8'h28;    8'hef: o = 8'hdf;
        8'hf0: o = 8'h8c;    8'hf1: o = 8'ha1;    8'hf2: o = 8'h89;    8'hf3: o = 8'h0d;
        8'hf4: o = 8'hbf;    8'hf5: o = 8'he6;    8'hf6: o = 8'h42;    8'hf7: o = 8'h68;
        8'hf8: o = 8'h41;    8'hf9: o = 8'h99;    8'hfa: o = 8'h2d;    8'hfb: o = 8'h0f;
        8'hfc: o = 8'hb0;    8'hfd: o = 8'h54;    8'hfe: o = 8'hbb;    8'hff: o = 8'h16;
            default: o = 8'h0;
      endcase
    end
    assign y = o;
endmodule // SubBytes_Composite


/*



module SubBytes_Composite (x, y);
   input  [7:0] x;
   output [7:0] y;

   //------------------------------------------------
   wire [7:0]   a, b;

   //------------------------------------------------
   assign a = {x[5] ^ x[7],
               x[1] ^ x[2] ^ x[3] ^ x[4] ^ x[6] ^ x[7],
               x[2] ^ x[3] ^ x[5] ^ x[7],
               x[1] ^ x[2] ^ x[3] ^ x[5] ^ x[7],
               x[1] ^ x[2] ^ x[6] ^ x[7],
               x[1] ^ x[2] ^ x[3] ^ x[4] ^ x[7],
               x[1] ^ x[4] ^ x[6],
               x[0] ^ x[1] ^ x[6]};

   SubBytes_GFinv_Composite gfinv (.x(a), .y(b));

   assign y = { b[2] ^ b[3] ^ b[7],
               ~b[4] ^ b[5] ^ b[6] ^ b[7],
               ~b[2] ^ b[7],
                b[0] ^ b[1] ^ b[4] ^ b[7],
                b[0] ^ b[1] ^ b[2],
                b[0] ^ b[2] ^ b[3] ^ b[4] ^ b[5] ^ b[6],
               ~b[0] ^ b[7],
               ~b[0] ^ b[1] ^ b[2] ^ b[6] ^ b[7]};
endmodule // SubBytes_Composite



//================================================ SubBytes_Composite
module SubBytes_GFinv_Composite(x, y);

   //------------------------------------------------
   input  [7:0] x;
   output [7:0] y;

   //------------------------------------------------
   wire [8:0]   da, db, dx, dy, va, tp, tn;
   wire [3:0]   u, v;
   wire [4:0]   mx;
   wire [5:0]   my;

   //------------------------------------------------
   assign da = {x[3],
                x[2] ^ x[3],
                x[2],
                x[1] ^ x[3],
                x[0] ^ x[1] ^ x[2] ^ x[3],
                x[0] ^ x[2],
                x[1],
                x[0] ^ x[1],
                x[0]};
   
   assign db = {x[7],
                x[6] ^ x[7],
                x[6], 
                x[5] ^ x[7], 
                x[4] ^ x[5] ^ x[6] ^ x[7],
                x[4] ^ x[6],
                x[5],
                x[4] ^ x[5],
                x[4]};
   
   assign va = {v[3],
                v[2] ^ v[3],
                v[2],
                v[1] ^ v[3],
                v[0] ^ v[1] ^ v[2] ^ v[3],
                v[0] ^ v[2],
                v[1],
                v[0] ^ v[1],
                v[0]};

   assign dx = da ^ db;
   assign dy = da & dx;
   assign tp = va & dx;
   assign tn = va & db;

   assign u = {dy[0] ^ dy[1] ^ dy[3] ^ dy[4] ^ x[4] ^ x[5] ^ x[6],
               dy[0] ^ dy[2] ^ dy[3] ^ dy[5] ^ x[4] ^ x[7],
               dy[0] ^ dy[1] ^ dy[7] ^ dy[8] ^ x[7],
               dy[0] ^ dy[2] ^ dy[6] ^ dy[7] ^ x[6] ^ x[7]};

   assign y = {tn[0] ^ tn[1] ^ tn[3] ^ tn[4], tn[0] ^ tn[2] ^ tn[3] ^ tn[5],
               tn[0] ^ tn[1] ^ tn[7] ^ tn[8], tn[0] ^ tn[2] ^ tn[6] ^ tn[7],
               tp[0] ^ tp[1] ^ tp[3] ^ tp[4], tp[0] ^ tp[2] ^ tp[3] ^ tp[5],
               tp[0] ^ tp[1] ^ tp[7] ^ tp[8], tp[0] ^ tp[2] ^ tp[6] ^ tp[7]};

   //---------------- GF(2^2^2) Inverter
   assign mx = {mx[0] ^ mx[1] ^ u[2],
                mx[0] ^ mx[2] ^ u[3],
                u[1] & (u[1] ^ u[3]),
               (u[0] ^ u[1]) & (u[0] ^ u[1]  ^ u[2] ^ u[3]),
                u[0] & (u[0] ^ u[2])};

   assign my = {~(mx[4] & u[3]),
                ~(mx[3] & (u[2] ^ u[3])),
                ~((mx[3] ^ mx[4]) & u[2]),
                ~(mx[4] & (u[1] ^ u[3])),
                ~(mx[3] & (u[0] ^ u[1]  ^ u[2] ^ u[3])),
                ~((mx[3] ^ mx[4]) & (u[0] ^ u[2]))};

   assign  v = {my[3] ^ my[4],
                my[3] ^ my[5],
                my[0] ^ my[1],
                my[0] ^ my[2]};
endmodule // SubBytes_GFinv_Composite

*/