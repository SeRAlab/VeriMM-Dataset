module top_module (
	input i,
	input j,
	input k,
	output l_sop,
	output l_pos);assign l_sop = (~i & ~j & ~k) | (~i & j & ~k) | (i & ~j & k);
	assign l_pos = (i | j | ~k) & (i | ~j | k) & (~i | j | k);
endmodule