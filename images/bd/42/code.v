module top_module (
	input [3:0] g,
	output [3:0] out);assign out = g << 3;

endmodule