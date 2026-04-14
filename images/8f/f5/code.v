module top_module(in, sum);input [35:0]in;
	output [5:0]sum;
	
	wire [17:0] sum_3;
  wire [8:0] sum_4;
  wire [3:0] sum_5;
  wire [1:0] sum_6;
	wire [7:0] cout;

  assign {cout[2], sum_3} = in[0+:18] + in[18+:18];
	assign sum_4 = {sum_3[16], sum_3[14], sum_3[12], sum_3[10], sum_3[8], sum_3[6], sum_3[4], sum_3[2], sum_3[0]};
	assign cout[3] = cout[2];
	
  assign {cout[4], sum_5} = sum_4[0+:4] + sum_4[4+:4] + sum_4[8];
	assign sum_6 = {sum_5[2], sum_5[0]};
	assign cout[5] = cout[4];
	
  assign {cout[6], cout[7]} = sum_6[0] + sum_6[1];
	
	assign sum = cout[7:2];endmodule