module top_module (
	input p,
	input q,
	input r,
	output s);assign s = (~((p | q) | r));
endmodule