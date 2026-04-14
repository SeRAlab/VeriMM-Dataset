module top_module(in, out, clear);input [0:15] in;
	output [0:15] out;
	input clear;

	assign out = !clear ? in : 0;endmodule