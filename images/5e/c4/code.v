module top_module (
	input p,
	input q,
	input r,
	output reg s);assign s = (p | q) & r;
endmodule