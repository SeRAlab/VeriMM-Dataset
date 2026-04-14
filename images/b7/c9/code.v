module top_module (
	input [15:0] a,
	input [15:0] b,
	input sel,
	output [15:0] out);

assign out = sel ? b : a;

endmodule