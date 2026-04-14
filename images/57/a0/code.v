module top_module (
	input m,
	input n,
	output p);
assign p = ~(m | n);
endmodule