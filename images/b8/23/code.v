module top_module (
	input l,
	input m,
	input n,
	input o,
	output p);
assign p = ~((l | m | n) & o);
endmodule