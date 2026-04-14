module top_module (
	input i,
	input j,
	input k,
	output out_sop,
	output out_pos);assign out_sop = (~i & ~j & k) | (i & ~j & ~k) | (i & j & ~k);
assign out_pos = (i | ~j | k) & (i | j | ~k) & (~i | ~j | k);
endmodule