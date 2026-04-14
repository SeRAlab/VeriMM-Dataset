module top_module(
	input u,
	input v,
	output reg w);assign w = ~(u | v);

endmodule