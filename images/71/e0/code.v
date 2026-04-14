module top_module (
	input [7:0] a,
	input [7:0] b,
	input [7:0] c,
	output [7:0] d);assign d = a & b & c;

endmodule