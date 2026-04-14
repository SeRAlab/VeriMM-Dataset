module top_module (
	input g,
	input h,
	input i,
	output out_sop,
	output out_pos);assign out_sop = (~g & ~h & i) | (~g & h & i) | (g & ~h & i) | (g & h & i);
assign out_pos = (~g | h | ~i) & (g | ~h | i);
endmodule