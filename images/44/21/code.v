module top_module(
	input m,
	input n,
	output reg o);assign o = ~(m | ~n);
	
endmodule