module top_module (
	input g,
	input h,
	input i,
	input j,
	output k_sop,
	output k_pos);assign k_sop = (~g & h & ~i & j) | (g & ~h & ~i & j) | (~g & h & i & j) | (g & h & ~i & j);
assign k_pos = (g | ~h | i | ~j) & (~g | h | i | ~j) & (~g | ~h | ~i | j) & (g | h | ~i | j);
endmodule