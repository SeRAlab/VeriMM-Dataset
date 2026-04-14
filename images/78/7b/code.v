module top_module (
	input [9:0] r,
	output [9:0] s);

assign s = r | 10'h3C3;

endmodule