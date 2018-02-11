`define high_pos(x,y)       1023 - (128*x+8*y)
`define low_pos(x,y)        `high_pos(x,y) - 7
`define high_pos2(x,y)       1023 - (64*x+8*y)
`define low_pos2(x,y)        `high_pos2(x,y) - 7

module MixBytes(in, out);
	input  [1023:0] in;
	output [1023:0] out;
  
    genvar i, j;
	
	wire [7:0]     x[7:0][15:0];	
	wire [7:0]     y[7:0][15:0];

	
   function [7:0] mul_2;
      input [7:0] din;
      begin
	 mul_2[7] = din[6];
	 mul_2[6] = din[5];
	 mul_2[5] = din[4];
	 mul_2[4] = din[3] ^ din[7];
	 mul_2[3] = din[2] ^ din[7];
	 mul_2[2] = din[1];
	 mul_2[1] = din[0] ^ din[7];
	 mul_2[0] = din[7];
      end
   endfunction		
   
   function [7:0] mul_3;
      input [7:0] din;
      begin
		mul_3[7] = din[7] ^ din[6];
		mul_3[6] = din[6] ^ din[5];
		mul_3[5] = din[5] ^ din[4];
		mul_3[4] = din[7] ^ din[4] ^ din[3];
		mul_3[3] = din[7] ^ din[3] ^ din[2];
		mul_3[2] = din[2] ^ din[1];
		mul_3[1] = din[7] ^ din[1] ^ din[0];
		mul_3[0] = din[7] ^ din[0];

      end
   endfunction	  
   
   function [7:0] mul_4;
      input [7:0] din;
      begin
	mul_4[7] = din[5];
	mul_4[6] = din[4];
	mul_4[5] = din[7] ^ din[3];
	mul_4[4] = din[7] ^ din[6] ^ din[2];
	mul_4[3] = din[6] ^ din[1];
	mul_4[2] = din[7] ^ din[0];
	mul_4[1] = din[7] ^ din[6];
	mul_4[0] = din[6]; 
      end
   endfunction
   
   function [7:0] mul_5;
      input [7:0] din;
      begin
	mul_5[7] = din[5] ^ din[7];
	mul_5[6] = din[4] ^ din[6];
	mul_5[5] = din[3] ^ din[5] ^ din[7];
	mul_5[4] = din[2] ^ din[4] ^ din[6] ^ din[7];
	mul_5[3] = din[1] ^ din[3] ^ din[6];
	mul_5[2] = din[0] ^ din[2] ^ din[7];
	mul_5[1] = din[1] ^ din[6] ^ din[7];
	mul_5[0] = din[0] ^ din[6];
      end
   endfunction
	
   function [7:0] mul_7;
      input [7:0] din;
      begin
	mul_7[7] = din[5] ^ din[6] ^ din[7];
	mul_7[6] = din[4] ^ din[5] ^ din[6];
	mul_7[5] = din[3] ^ din[4] ^ din[5] ^ din[7];
	mul_7[4] = din[2] ^ din[3] ^ din[4] ^ din[6];
	mul_7[3] = din[1] ^ din[2] ^ din[3] ^ din[6] ^ din[7];
	mul_7[2] = din[0] ^ din[1] ^ din[2] ^ din[7];
	mul_7[1] = din[0] ^ din[1] ^ din[6];
	mul_7[0] = din[0] ^ din[6] ^ din[7]; 
      end
   endfunction	
	
    generate
      for(i=0; i<8; i=i+1)
        begin : L0
          for(j=0; j<16; j=j+1)
            begin : L1
				assign x[i][j] = in[`high_pos(i,j):`low_pos(i,j)];		
			end
        end
    endgenerate  	
//

assign y[0][0] = mul_2(x[0][0])^mul_2(x[1][0])^mul_3(x[2][0])^mul_4(x[3][0])^mul_5(x[4][0])^mul_3(x[5][0])^mul_5(x[6][0])^mul_7(x[7][0]);	
assign y[1][0] = mul_2(x[1][0])^mul_2(x[2][0])^mul_3(x[3][0])^mul_4(x[4][0])^mul_5(x[5][0])^mul_3(x[6][0])^mul_5(x[7][0])^mul_7(x[0][0]);
assign y[2][0] = mul_2(x[2][0])^mul_2(x[3][0])^mul_3(x[4][0])^mul_4(x[5][0])^mul_5(x[6][0])^mul_3(x[7][0])^mul_5(x[0][0])^mul_7(x[1][0]);
assign y[3][0] = mul_2(x[3][0])^mul_2(x[4][0])^mul_3(x[5][0])^mul_4(x[6][0])^mul_5(x[7][0])^mul_3(x[0][0])^mul_5(x[1][0])^mul_7(x[2][0]);
assign y[4][0] = mul_2(x[4][0])^mul_2(x[5][0])^mul_3(x[6][0])^mul_4(x[7][0])^mul_5(x[0][0])^mul_3(x[1][0])^mul_5(x[2][0])^mul_7(x[3][0]);
assign y[5][0] = mul_2(x[5][0])^mul_2(x[6][0])^mul_3(x[7][0])^mul_4(x[0][0])^mul_5(x[1][0])^mul_3(x[2][0])^mul_5(x[3][0])^mul_7(x[4][0]);
assign y[6][0] = mul_2(x[6][0])^mul_2(x[7][0])^mul_3(x[0][0])^mul_4(x[1][0])^mul_5(x[2][0])^mul_3(x[3][0])^mul_5(x[4][0])^mul_7(x[5][0]);
assign y[7][0] = mul_2(x[7][0])^mul_2(x[0][0])^mul_3(x[1][0])^mul_4(x[2][0])^mul_5(x[3][0])^mul_3(x[4][0])^mul_5(x[5][0])^mul_7(x[6][0]);

assign y[0][1] = mul_2(x[0][1])^mul_2(x[1][1])^mul_3(x[2][1])^mul_4(x[3][1])^mul_5(x[4][1])^mul_3(x[5][1])^mul_5(x[6][1])^mul_7(x[7][1]);
assign y[1][1] = mul_2(x[1][1])^mul_2(x[2][1])^mul_3(x[3][1])^mul_4(x[4][1])^mul_5(x[5][1])^mul_3(x[6][1])^mul_5(x[7][1])^mul_7(x[0][1]);
assign y[2][1] = mul_2(x[2][1])^mul_2(x[3][1])^mul_3(x[4][1])^mul_4(x[5][1])^mul_5(x[6][1])^mul_3(x[7][1])^mul_5(x[0][1])^mul_7(x[1][1]);
assign y[3][1] = mul_2(x[3][1])^mul_2(x[4][1])^mul_3(x[5][1])^mul_4(x[6][1])^mul_5(x[7][1])^mul_3(x[0][1])^mul_5(x[1][1])^mul_7(x[2][1]);
assign y[4][1] = mul_2(x[4][1])^mul_2(x[5][1])^mul_3(x[6][1])^mul_4(x[7][1])^mul_5(x[0][1])^mul_3(x[1][1])^mul_5(x[2][1])^mul_7(x[3][1]);
assign y[5][1] = mul_2(x[5][1])^mul_2(x[6][1])^mul_3(x[7][1])^mul_4(x[0][1])^mul_5(x[1][1])^mul_3(x[2][1])^mul_5(x[3][1])^mul_7(x[4][1]);
assign y[6][1] = mul_2(x[6][1])^mul_2(x[7][1])^mul_3(x[0][1])^mul_4(x[1][1])^mul_5(x[2][1])^mul_3(x[3][1])^mul_5(x[4][1])^mul_7(x[5][1]);
assign y[7][1] = mul_2(x[7][1])^mul_2(x[0][1])^mul_3(x[1][1])^mul_4(x[2][1])^mul_5(x[3][1])^mul_3(x[4][1])^mul_5(x[5][1])^mul_7(x[6][1]);

assign y[0][2] = mul_2(x[0][2])^mul_2(x[1][2])^mul_3(x[2][2])^mul_4(x[3][2])^mul_5(x[4][2])^mul_3(x[5][2])^mul_5(x[6][2])^mul_7(x[7][2]);
assign y[1][2] = mul_2(x[1][2])^mul_2(x[2][2])^mul_3(x[3][2])^mul_4(x[4][2])^mul_5(x[5][2])^mul_3(x[6][2])^mul_5(x[7][2])^mul_7(x[0][2]);
assign y[2][2] = mul_2(x[2][2])^mul_2(x[3][2])^mul_3(x[4][2])^mul_4(x[5][2])^mul_5(x[6][2])^mul_3(x[7][2])^mul_5(x[0][2])^mul_7(x[1][2]);
assign y[3][2] = mul_2(x[3][2])^mul_2(x[4][2])^mul_3(x[5][2])^mul_4(x[6][2])^mul_5(x[7][2])^mul_3(x[0][2])^mul_5(x[1][2])^mul_7(x[2][2]);
assign y[4][2] = mul_2(x[4][2])^mul_2(x[5][2])^mul_3(x[6][2])^mul_4(x[7][2])^mul_5(x[0][2])^mul_3(x[1][2])^mul_5(x[2][2])^mul_7(x[3][2]);
assign y[5][2] = mul_2(x[5][2])^mul_2(x[6][2])^mul_3(x[7][2])^mul_4(x[0][2])^mul_5(x[1][2])^mul_3(x[2][2])^mul_5(x[3][2])^mul_7(x[4][2]);
assign y[6][2] = mul_2(x[6][2])^mul_2(x[7][2])^mul_3(x[0][2])^mul_4(x[1][2])^mul_5(x[2][2])^mul_3(x[3][2])^mul_5(x[4][2])^mul_7(x[5][2]);
assign y[7][2] = mul_2(x[7][2])^mul_2(x[0][2])^mul_3(x[1][2])^mul_4(x[2][2])^mul_5(x[3][2])^mul_3(x[4][2])^mul_5(x[5][2])^mul_7(x[6][2]);

assign y[0][3] = mul_2(x[0][3])^mul_2(x[1][3])^mul_3(x[2][3])^mul_4(x[3][3])^mul_5(x[4][3])^mul_3(x[5][3])^mul_5(x[6][3])^mul_7(x[7][3]);
assign y[1][3] = mul_2(x[1][3])^mul_2(x[2][3])^mul_3(x[3][3])^mul_4(x[4][3])^mul_5(x[5][3])^mul_3(x[6][3])^mul_5(x[7][3])^mul_7(x[0][3]);
assign y[2][3] = mul_2(x[2][3])^mul_2(x[3][3])^mul_3(x[4][3])^mul_4(x[5][3])^mul_5(x[6][3])^mul_3(x[7][3])^mul_5(x[0][3])^mul_7(x[1][3]);
assign y[3][3] = mul_2(x[3][3])^mul_2(x[4][3])^mul_3(x[5][3])^mul_4(x[6][3])^mul_5(x[7][3])^mul_3(x[0][3])^mul_5(x[1][3])^mul_7(x[2][3]);
assign y[4][3] = mul_2(x[4][3])^mul_2(x[5][3])^mul_3(x[6][3])^mul_4(x[7][3])^mul_5(x[0][3])^mul_3(x[1][3])^mul_5(x[2][3])^mul_7(x[3][3]);
assign y[5][3] = mul_2(x[5][3])^mul_2(x[6][3])^mul_3(x[7][3])^mul_4(x[0][3])^mul_5(x[1][3])^mul_3(x[2][3])^mul_5(x[3][3])^mul_7(x[4][3]);
assign y[6][3] = mul_2(x[6][3])^mul_2(x[7][3])^mul_3(x[0][3])^mul_4(x[1][3])^mul_5(x[2][3])^mul_3(x[3][3])^mul_5(x[4][3])^mul_7(x[5][3]);
assign y[7][3] = mul_2(x[7][3])^mul_2(x[0][3])^mul_3(x[1][3])^mul_4(x[2][3])^mul_5(x[3][3])^mul_3(x[4][3])^mul_5(x[5][3])^mul_7(x[6][3]);

assign y[0][4] = mul_2(x[0][4])^mul_2(x[1][4])^mul_3(x[2][4])^mul_4(x[3][4])^mul_5(x[4][4])^mul_3(x[5][4])^mul_5(x[6][4])^mul_7(x[7][4]);
assign y[1][4] = mul_2(x[1][4])^mul_2(x[2][4])^mul_3(x[3][4])^mul_4(x[4][4])^mul_5(x[5][4])^mul_3(x[6][4])^mul_5(x[7][4])^mul_7(x[0][4]);
assign y[2][4] = mul_2(x[2][4])^mul_2(x[3][4])^mul_3(x[4][4])^mul_4(x[5][4])^mul_5(x[6][4])^mul_3(x[7][4])^mul_5(x[0][4])^mul_7(x[1][4]);
assign y[3][4] = mul_2(x[3][4])^mul_2(x[4][4])^mul_3(x[5][4])^mul_4(x[6][4])^mul_5(x[7][4])^mul_3(x[0][4])^mul_5(x[1][4])^mul_7(x[2][4]);
assign y[4][4] = mul_2(x[4][4])^mul_2(x[5][4])^mul_3(x[6][4])^mul_4(x[7][4])^mul_5(x[0][4])^mul_3(x[1][4])^mul_5(x[2][4])^mul_7(x[3][4]);
assign y[5][4] = mul_2(x[5][4])^mul_2(x[6][4])^mul_3(x[7][4])^mul_4(x[0][4])^mul_5(x[1][4])^mul_3(x[2][4])^mul_5(x[3][4])^mul_7(x[4][4]);
assign y[6][4] = mul_2(x[6][4])^mul_2(x[7][4])^mul_3(x[0][4])^mul_4(x[1][4])^mul_5(x[2][4])^mul_3(x[3][4])^mul_5(x[4][4])^mul_7(x[5][4]);
assign y[7][4] = mul_2(x[7][4])^mul_2(x[0][4])^mul_3(x[1][4])^mul_4(x[2][4])^mul_5(x[3][4])^mul_3(x[4][4])^mul_5(x[5][4])^mul_7(x[6][4]);

assign y[0][5] = mul_2(x[0][5])^mul_2(x[1][5])^mul_3(x[2][5])^mul_4(x[3][5])^mul_5(x[4][5])^mul_3(x[5][5])^mul_5(x[6][5])^mul_7(x[7][5]);
assign y[1][5] = mul_2(x[1][5])^mul_2(x[2][5])^mul_3(x[3][5])^mul_4(x[4][5])^mul_5(x[5][5])^mul_3(x[6][5])^mul_5(x[7][5])^mul_7(x[0][5]);
assign y[2][5] = mul_2(x[2][5])^mul_2(x[3][5])^mul_3(x[4][5])^mul_4(x[5][5])^mul_5(x[6][5])^mul_3(x[7][5])^mul_5(x[0][5])^mul_7(x[1][5]);
assign y[3][5] = mul_2(x[3][5])^mul_2(x[4][5])^mul_3(x[5][5])^mul_4(x[6][5])^mul_5(x[7][5])^mul_3(x[0][5])^mul_5(x[1][5])^mul_7(x[2][5]);
assign y[4][5] = mul_2(x[4][5])^mul_2(x[5][5])^mul_3(x[6][5])^mul_4(x[7][5])^mul_5(x[0][5])^mul_3(x[1][5])^mul_5(x[2][5])^mul_7(x[3][5]);
assign y[5][5] = mul_2(x[5][5])^mul_2(x[6][5])^mul_3(x[7][5])^mul_4(x[0][5])^mul_5(x[1][5])^mul_3(x[2][5])^mul_5(x[3][5])^mul_7(x[4][5]);
assign y[6][5] = mul_2(x[6][5])^mul_2(x[7][5])^mul_3(x[0][5])^mul_4(x[1][5])^mul_5(x[2][5])^mul_3(x[3][5])^mul_5(x[4][5])^mul_7(x[5][5]);
assign y[7][5] = mul_2(x[7][5])^mul_2(x[0][5])^mul_3(x[1][5])^mul_4(x[2][5])^mul_5(x[3][5])^mul_3(x[4][5])^mul_5(x[5][5])^mul_7(x[6][5]);

assign y[0][6] = mul_2(x[0][6])^mul_2(x[1][6])^mul_3(x[2][6])^mul_4(x[3][6])^mul_5(x[4][6])^mul_3(x[5][6])^mul_5(x[6][6])^mul_7(x[7][6]);
assign y[1][6] = mul_2(x[1][6])^mul_2(x[2][6])^mul_3(x[3][6])^mul_4(x[4][6])^mul_5(x[5][6])^mul_3(x[6][6])^mul_5(x[7][6])^mul_7(x[0][6]);
assign y[2][6] = mul_2(x[2][6])^mul_2(x[3][6])^mul_3(x[4][6])^mul_4(x[5][6])^mul_5(x[6][6])^mul_3(x[7][6])^mul_5(x[0][6])^mul_7(x[1][6]);
assign y[3][6] = mul_2(x[3][6])^mul_2(x[4][6])^mul_3(x[5][6])^mul_4(x[6][6])^mul_5(x[7][6])^mul_3(x[0][6])^mul_5(x[1][6])^mul_7(x[2][6]);
assign y[4][6] = mul_2(x[4][6])^mul_2(x[5][6])^mul_3(x[6][6])^mul_4(x[7][6])^mul_5(x[0][6])^mul_3(x[1][6])^mul_5(x[2][6])^mul_7(x[3][6]);
assign y[5][6] = mul_2(x[5][6])^mul_2(x[6][6])^mul_3(x[7][6])^mul_4(x[0][6])^mul_5(x[1][6])^mul_3(x[2][6])^mul_5(x[3][6])^mul_7(x[4][6]);
assign y[6][6] = mul_2(x[6][6])^mul_2(x[7][6])^mul_3(x[0][6])^mul_4(x[1][6])^mul_5(x[2][6])^mul_3(x[3][6])^mul_5(x[4][6])^mul_7(x[5][6]);
assign y[7][6] = mul_2(x[7][6])^mul_2(x[0][6])^mul_3(x[1][6])^mul_4(x[2][6])^mul_5(x[3][6])^mul_3(x[4][6])^mul_5(x[5][6])^mul_7(x[6][6]);

assign y[0][7] = mul_2(x[0][7])^mul_2(x[1][7])^mul_3(x[2][7])^mul_4(x[3][7])^mul_5(x[4][7])^mul_3(x[5][7])^mul_5(x[6][7])^mul_7(x[7][7]);
assign y[1][7] = mul_2(x[1][7])^mul_2(x[2][7])^mul_3(x[3][7])^mul_4(x[4][7])^mul_5(x[5][7])^mul_3(x[6][7])^mul_5(x[7][7])^mul_7(x[0][7]);
assign y[2][7] = mul_2(x[2][7])^mul_2(x[3][7])^mul_3(x[4][7])^mul_4(x[5][7])^mul_5(x[6][7])^mul_3(x[7][7])^mul_5(x[0][7])^mul_7(x[1][7]);
assign y[3][7] = mul_2(x[3][7])^mul_2(x[4][7])^mul_3(x[5][7])^mul_4(x[6][7])^mul_5(x[7][7])^mul_3(x[0][7])^mul_5(x[1][7])^mul_7(x[2][7]);
assign y[4][7] = mul_2(x[4][7])^mul_2(x[5][7])^mul_3(x[6][7])^mul_4(x[7][7])^mul_5(x[0][7])^mul_3(x[1][7])^mul_5(x[2][7])^mul_7(x[3][7]);
assign y[5][7] = mul_2(x[5][7])^mul_2(x[6][7])^mul_3(x[7][7])^mul_4(x[0][7])^mul_5(x[1][7])^mul_3(x[2][7])^mul_5(x[3][7])^mul_7(x[4][7]);
assign y[6][7] = mul_2(x[6][7])^mul_2(x[7][7])^mul_3(x[0][7])^mul_4(x[1][7])^mul_5(x[2][7])^mul_3(x[3][7])^mul_5(x[4][7])^mul_7(x[5][7]);
assign y[7][7] = mul_2(x[7][7])^mul_2(x[0][7])^mul_3(x[1][7])^mul_4(x[2][7])^mul_5(x[3][7])^mul_3(x[4][7])^mul_5(x[5][7])^mul_7(x[6][7]);

assign y[0][8] = mul_2(x[0][8])^mul_2(x[1][8])^mul_3(x[2][8])^mul_4(x[3][8])^mul_5(x[4][8])^mul_3(x[5][8])^mul_5(x[6][8])^mul_7(x[7][8]);
assign y[1][8] = mul_2(x[1][8])^mul_2(x[2][8])^mul_3(x[3][8])^mul_4(x[4][8])^mul_5(x[5][8])^mul_3(x[6][8])^mul_5(x[7][8])^mul_7(x[0][8]);
assign y[2][8] = mul_2(x[2][8])^mul_2(x[3][8])^mul_3(x[4][8])^mul_4(x[5][8])^mul_5(x[6][8])^mul_3(x[7][8])^mul_5(x[0][8])^mul_7(x[1][8]);
assign y[3][8] = mul_2(x[3][8])^mul_2(x[4][8])^mul_3(x[5][8])^mul_4(x[6][8])^mul_5(x[7][8])^mul_3(x[0][8])^mul_5(x[1][8])^mul_7(x[2][8]);
assign y[4][8] = mul_2(x[4][8])^mul_2(x[5][8])^mul_3(x[6][8])^mul_4(x[7][8])^mul_5(x[0][8])^mul_3(x[1][8])^mul_5(x[2][8])^mul_7(x[3][8]);
assign y[5][8] = mul_2(x[5][8])^mul_2(x[6][8])^mul_3(x[7][8])^mul_4(x[0][8])^mul_5(x[1][8])^mul_3(x[2][8])^mul_5(x[3][8])^mul_7(x[4][8]);
assign y[6][8] = mul_2(x[6][8])^mul_2(x[7][8])^mul_3(x[0][8])^mul_4(x[1][8])^mul_5(x[2][8])^mul_3(x[3][8])^mul_5(x[4][8])^mul_7(x[5][8]);
assign y[7][8] = mul_2(x[7][8])^mul_2(x[0][8])^mul_3(x[1][8])^mul_4(x[2][8])^mul_5(x[3][8])^mul_3(x[4][8])^mul_5(x[5][8])^mul_7(x[6][8]);

assign y[0][9] = mul_2(x[0][9])^mul_2(x[1][9])^mul_3(x[2][9])^mul_4(x[3][9])^mul_5(x[4][9])^mul_3(x[5][9])^mul_5(x[6][9])^mul_7(x[7][9]);
assign y[1][9] = mul_2(x[1][9])^mul_2(x[2][9])^mul_3(x[3][9])^mul_4(x[4][9])^mul_5(x[5][9])^mul_3(x[6][9])^mul_5(x[7][9])^mul_7(x[0][9]);
assign y[2][9] = mul_2(x[2][9])^mul_2(x[3][9])^mul_3(x[4][9])^mul_4(x[5][9])^mul_5(x[6][9])^mul_3(x[7][9])^mul_5(x[0][9])^mul_7(x[1][9]);
assign y[3][9] = mul_2(x[3][9])^mul_2(x[4][9])^mul_3(x[5][9])^mul_4(x[6][9])^mul_5(x[7][9])^mul_3(x[0][9])^mul_5(x[1][9])^mul_7(x[2][9]);
assign y[4][9] = mul_2(x[4][9])^mul_2(x[5][9])^mul_3(x[6][9])^mul_4(x[7][9])^mul_5(x[0][9])^mul_3(x[1][9])^mul_5(x[2][9])^mul_7(x[3][9]);
assign y[5][9] = mul_2(x[5][9])^mul_2(x[6][9])^mul_3(x[7][9])^mul_4(x[0][9])^mul_5(x[1][9])^mul_3(x[2][9])^mul_5(x[3][9])^mul_7(x[4][9]);
assign y[6][9] = mul_2(x[6][9])^mul_2(x[7][9])^mul_3(x[0][9])^mul_4(x[1][9])^mul_5(x[2][9])^mul_3(x[3][9])^mul_5(x[4][9])^mul_7(x[5][9]);
assign y[7][9] = mul_2(x[7][9])^mul_2(x[0][9])^mul_3(x[1][9])^mul_4(x[2][9])^mul_5(x[3][9])^mul_3(x[4][9])^mul_5(x[5][9])^mul_7(x[6][9]);

assign y[0][10] = mul_2(x[0][10])^mul_2(x[1][10])^mul_3(x[2][10])^mul_4(x[3][10])^mul_5(x[4][10])^mul_3(x[5][10])^mul_5(x[6][10])^mul_7(x[7][10]);
assign y[1][10] = mul_2(x[1][10])^mul_2(x[2][10])^mul_3(x[3][10])^mul_4(x[4][10])^mul_5(x[5][10])^mul_3(x[6][10])^mul_5(x[7][10])^mul_7(x[0][10]);
assign y[2][10] = mul_2(x[2][10])^mul_2(x[3][10])^mul_3(x[4][10])^mul_4(x[5][10])^mul_5(x[6][10])^mul_3(x[7][10])^mul_5(x[0][10])^mul_7(x[1][10]);
assign y[3][10] = mul_2(x[3][10])^mul_2(x[4][10])^mul_3(x[5][10])^mul_4(x[6][10])^mul_5(x[7][10])^mul_3(x[0][10])^mul_5(x[1][10])^mul_7(x[2][10]);
assign y[4][10] = mul_2(x[4][10])^mul_2(x[5][10])^mul_3(x[6][10])^mul_4(x[7][10])^mul_5(x[0][10])^mul_3(x[1][10])^mul_5(x[2][10])^mul_7(x[3][10]);
assign y[5][10] = mul_2(x[5][10])^mul_2(x[6][10])^mul_3(x[7][10])^mul_4(x[0][10])^mul_5(x[1][10])^mul_3(x[2][10])^mul_5(x[3][10])^mul_7(x[4][10]);
assign y[6][10] = mul_2(x[6][10])^mul_2(x[7][10])^mul_3(x[0][10])^mul_4(x[1][10])^mul_5(x[2][10])^mul_3(x[3][10])^mul_5(x[4][10])^mul_7(x[5][10]);
assign y[7][10] = mul_2(x[7][10])^mul_2(x[0][10])^mul_3(x[1][10])^mul_4(x[2][10])^mul_5(x[3][10])^mul_3(x[4][10])^mul_5(x[5][10])^mul_7(x[6][10]);

assign y[0][11] = mul_2(x[0][11])^mul_2(x[1][11])^mul_3(x[2][11])^mul_4(x[3][11])^mul_5(x[4][11])^mul_3(x[5][11])^mul_5(x[6][11])^mul_7(x[7][11]);
assign y[1][11] = mul_2(x[1][11])^mul_2(x[2][11])^mul_3(x[3][11])^mul_4(x[4][11])^mul_5(x[5][11])^mul_3(x[6][11])^mul_5(x[7][11])^mul_7(x[0][11]);
assign y[2][11] = mul_2(x[2][11])^mul_2(x[3][11])^mul_3(x[4][11])^mul_4(x[5][11])^mul_5(x[6][11])^mul_3(x[7][11])^mul_5(x[0][11])^mul_7(x[1][11]);
assign y[3][11] = mul_2(x[3][11])^mul_2(x[4][11])^mul_3(x[5][11])^mul_4(x[6][11])^mul_5(x[7][11])^mul_3(x[0][11])^mul_5(x[1][11])^mul_7(x[2][11]);
assign y[4][11] = mul_2(x[4][11])^mul_2(x[5][11])^mul_3(x[6][11])^mul_4(x[7][11])^mul_5(x[0][11])^mul_3(x[1][11])^mul_5(x[2][11])^mul_7(x[3][11]);
assign y[5][11] = mul_2(x[5][11])^mul_2(x[6][11])^mul_3(x[7][11])^mul_4(x[0][11])^mul_5(x[1][11])^mul_3(x[2][11])^mul_5(x[3][11])^mul_7(x[4][11]);
assign y[6][11] = mul_2(x[6][11])^mul_2(x[7][11])^mul_3(x[0][11])^mul_4(x[1][11])^mul_5(x[2][11])^mul_3(x[3][11])^mul_5(x[4][11])^mul_7(x[5][11]);
assign y[7][11] = mul_2(x[7][11])^mul_2(x[0][11])^mul_3(x[1][11])^mul_4(x[2][11])^mul_5(x[3][11])^mul_3(x[4][11])^mul_5(x[5][11])^mul_7(x[6][11]);

assign y[0][12] = mul_2(x[0][12])^mul_2(x[1][12])^mul_3(x[2][12])^mul_4(x[3][12])^mul_5(x[4][12])^mul_3(x[5][12])^mul_5(x[6][12])^mul_7(x[7][12]);
assign y[1][12] = mul_2(x[1][12])^mul_2(x[2][12])^mul_3(x[3][12])^mul_4(x[4][12])^mul_5(x[5][12])^mul_3(x[6][12])^mul_5(x[7][12])^mul_7(x[0][12]);
assign y[2][12] = mul_2(x[2][12])^mul_2(x[3][12])^mul_3(x[4][12])^mul_4(x[5][12])^mul_5(x[6][12])^mul_3(x[7][12])^mul_5(x[0][12])^mul_7(x[1][12]);
assign y[3][12] = mul_2(x[3][12])^mul_2(x[4][12])^mul_3(x[5][12])^mul_4(x[6][12])^mul_5(x[7][12])^mul_3(x[0][12])^mul_5(x[1][12])^mul_7(x[2][12]);
assign y[4][12] = mul_2(x[4][12])^mul_2(x[5][12])^mul_3(x[6][12])^mul_4(x[7][12])^mul_5(x[0][12])^mul_3(x[1][12])^mul_5(x[2][12])^mul_7(x[3][12]);
assign y[5][12] = mul_2(x[5][12])^mul_2(x[6][12])^mul_3(x[7][12])^mul_4(x[0][12])^mul_5(x[1][12])^mul_3(x[2][12])^mul_5(x[3][12])^mul_7(x[4][12]);
assign y[6][12] = mul_2(x[6][12])^mul_2(x[7][12])^mul_3(x[0][12])^mul_4(x[1][12])^mul_5(x[2][12])^mul_3(x[3][12])^mul_5(x[4][12])^mul_7(x[5][12]);
assign y[7][12] = mul_2(x[7][12])^mul_2(x[0][12])^mul_3(x[1][12])^mul_4(x[2][12])^mul_5(x[3][12])^mul_3(x[4][12])^mul_5(x[5][12])^mul_7(x[6][12]);

assign y[0][13] = mul_2(x[0][13])^mul_2(x[1][13])^mul_3(x[2][13])^mul_4(x[3][13])^mul_5(x[4][13])^mul_3(x[5][13])^mul_5(x[6][13])^mul_7(x[7][13]);
assign y[1][13] = mul_2(x[1][13])^mul_2(x[2][13])^mul_3(x[3][13])^mul_4(x[4][13])^mul_5(x[5][13])^mul_3(x[6][13])^mul_5(x[7][13])^mul_7(x[0][13]);
assign y[2][13] = mul_2(x[2][13])^mul_2(x[3][13])^mul_3(x[4][13])^mul_4(x[5][13])^mul_5(x[6][13])^mul_3(x[7][13])^mul_5(x[0][13])^mul_7(x[1][13]);
assign y[3][13] = mul_2(x[3][13])^mul_2(x[4][13])^mul_3(x[5][13])^mul_4(x[6][13])^mul_5(x[7][13])^mul_3(x[0][13])^mul_5(x[1][13])^mul_7(x[2][13]);
assign y[4][13] = mul_2(x[4][13])^mul_2(x[5][13])^mul_3(x[6][13])^mul_4(x[7][13])^mul_5(x[0][13])^mul_3(x[1][13])^mul_5(x[2][13])^mul_7(x[3][13]);
assign y[5][13] = mul_2(x[5][13])^mul_2(x[6][13])^mul_3(x[7][13])^mul_4(x[0][13])^mul_5(x[1][13])^mul_3(x[2][13])^mul_5(x[3][13])^mul_7(x[4][13]);
assign y[6][13] = mul_2(x[6][13])^mul_2(x[7][13])^mul_3(x[0][13])^mul_4(x[1][13])^mul_5(x[2][13])^mul_3(x[3][13])^mul_5(x[4][13])^mul_7(x[5][13]);
assign y[7][13] = mul_2(x[7][13])^mul_2(x[0][13])^mul_3(x[1][13])^mul_4(x[2][13])^mul_5(x[3][13])^mul_3(x[4][13])^mul_5(x[5][13])^mul_7(x[6][13]);

assign y[0][14] = mul_2(x[0][14])^mul_2(x[1][14])^mul_3(x[2][14])^mul_4(x[3][14])^mul_5(x[4][14])^mul_3(x[5][14])^mul_5(x[6][14])^mul_7(x[7][14]);
assign y[1][14] = mul_2(x[1][14])^mul_2(x[2][14])^mul_3(x[3][14])^mul_4(x[4][14])^mul_5(x[5][14])^mul_3(x[6][14])^mul_5(x[7][14])^mul_7(x[0][14]);
assign y[2][14] = mul_2(x[2][14])^mul_2(x[3][14])^mul_3(x[4][14])^mul_4(x[5][14])^mul_5(x[6][14])^mul_3(x[7][14])^mul_5(x[0][14])^mul_7(x[1][14]);
assign y[3][14] = mul_2(x[3][14])^mul_2(x[4][14])^mul_3(x[5][14])^mul_4(x[6][14])^mul_5(x[7][14])^mul_3(x[0][14])^mul_5(x[1][14])^mul_7(x[2][14]);
assign y[4][14] = mul_2(x[4][14])^mul_2(x[5][14])^mul_3(x[6][14])^mul_4(x[7][14])^mul_5(x[0][14])^mul_3(x[1][14])^mul_5(x[2][14])^mul_7(x[3][14]);
assign y[5][14] = mul_2(x[5][14])^mul_2(x[6][14])^mul_3(x[7][14])^mul_4(x[0][14])^mul_5(x[1][14])^mul_3(x[2][14])^mul_5(x[3][14])^mul_7(x[4][14]);
assign y[6][14] = mul_2(x[6][14])^mul_2(x[7][14])^mul_3(x[0][14])^mul_4(x[1][14])^mul_5(x[2][14])^mul_3(x[3][14])^mul_5(x[4][14])^mul_7(x[5][14]);
assign y[7][14] = mul_2(x[7][14])^mul_2(x[0][14])^mul_3(x[1][14])^mul_4(x[2][14])^mul_5(x[3][14])^mul_3(x[4][14])^mul_5(x[5][14])^mul_7(x[6][14]);

assign y[0][15] = mul_2(x[0][15])^mul_2(x[1][15])^mul_3(x[2][15])^mul_4(x[3][15])^mul_5(x[4][15])^mul_3(x[5][15])^mul_5(x[6][15])^mul_7(x[7][15]);
assign y[1][15] = mul_2(x[1][15])^mul_2(x[2][15])^mul_3(x[3][15])^mul_4(x[4][15])^mul_5(x[5][15])^mul_3(x[6][15])^mul_5(x[7][15])^mul_7(x[0][15]);
assign y[2][15] = mul_2(x[2][15])^mul_2(x[3][15])^mul_3(x[4][15])^mul_4(x[5][15])^mul_5(x[6][15])^mul_3(x[7][15])^mul_5(x[0][15])^mul_7(x[1][15]);
assign y[3][15] = mul_2(x[3][15])^mul_2(x[4][15])^mul_3(x[5][15])^mul_4(x[6][15])^mul_5(x[7][15])^mul_3(x[0][15])^mul_5(x[1][15])^mul_7(x[2][15]);
assign y[4][15] = mul_2(x[4][15])^mul_2(x[5][15])^mul_3(x[6][15])^mul_4(x[7][15])^mul_5(x[0][15])^mul_3(x[1][15])^mul_5(x[2][15])^mul_7(x[3][15]);
assign y[5][15] = mul_2(x[5][15])^mul_2(x[6][15])^mul_3(x[7][15])^mul_4(x[0][15])^mul_5(x[1][15])^mul_3(x[2][15])^mul_5(x[3][15])^mul_7(x[4][15]);
assign y[6][15] = mul_2(x[6][15])^mul_2(x[7][15])^mul_3(x[0][15])^mul_4(x[1][15])^mul_5(x[2][15])^mul_3(x[3][15])^mul_5(x[4][15])^mul_7(x[5][15]);
assign y[7][15] = mul_2(x[7][15])^mul_2(x[0][15])^mul_3(x[1][15])^mul_4(x[2][15])^mul_5(x[3][15])^mul_3(x[4][15])^mul_5(x[5][15])^mul_7(x[6][15]);



    generate
      for(i=0; i<8; i=i+1)
        begin : L2
          for(j=0; j<16; j=j+1)
            begin : L3
				assign out[`high_pos(i,j):`low_pos(i,j)] = y[i][j];				
            end
        end
    endgenerate  	
	
	
endmodule



`undef low_pos
`undef low_pos2
`undef high_pos
`undef high_pos2
