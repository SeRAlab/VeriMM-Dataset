module top_module(
	input [9:0] A, B,
	output [3:0] num);wire [9:0] temp;

assign temp = A^B;
assign num = temp[0] + temp[1] + temp[2] + temp[3] + temp [4] + temp[5] + temp[6]+ temp[7]+temp[8]+temp[9];

endmodule