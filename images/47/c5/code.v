module top_module(
	input subtract,
	input [7:0] B,
	output [7:0] S
);assign S = (subtract ? ~B+1 : B);
endmodule