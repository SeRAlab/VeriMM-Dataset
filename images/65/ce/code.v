module top_module (
	input m,
	input n,
	input o,
	output reg z);assign z = ~(m & n & o);
endmodule