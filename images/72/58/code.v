module top_module (
	input b,
	input c,
	output d);
assign d = ~(~(b | c));
endmodule