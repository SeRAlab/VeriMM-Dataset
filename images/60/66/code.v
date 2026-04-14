module top_module(
	input m,
	input n,
	output reg p);assign p = ~m & ~n;

endmodule