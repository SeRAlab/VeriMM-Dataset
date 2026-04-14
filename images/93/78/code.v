module top_module(
	input [31:0] in,
	output [31:0] out);specify
		(in => out) = 0.9;
	endspecify
	assign out = in;endmodule