module top_module(
	input c,
	input d,
	output reg e);assign e = ~(c | d);

endmodule