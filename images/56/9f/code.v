module top_module (
	input m,
	input n,
	input o,
	output reg p);assign p = (m | n) & o;
endmodule