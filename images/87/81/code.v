module top_module (
	input m,
	input n,
	output reg h);assign h = ~(m | n);
endmodule