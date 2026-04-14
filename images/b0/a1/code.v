module top_module(
	input [31:0] A,
	input [31:0] B,
	input Op,
	output reg [31:0] result
);always @ (Op or A or B)
	if (Op) result=A;
	else result=B;endmodule