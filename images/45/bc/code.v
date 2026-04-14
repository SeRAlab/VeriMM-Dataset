module top_module(
	input [4:0] A,
	input [4:0] B,
	input Op,
	output reg [4:0] result
);always @ (A or B or Op)
	if (Op) result=A;
	else result=B;endmodule