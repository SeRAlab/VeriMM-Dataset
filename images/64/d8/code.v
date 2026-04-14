module top_module (
	input g,
	input h,
	input i,
	output r_sop,
	output r_pos);assign r_sop = (~g & ~h & ~i) | (~g & h & ~i) | (~g & h & i);
	assign r_pos = (g | h | i) & (g | ~h | ~i) & (~g | ~h | ~i);
endmodule