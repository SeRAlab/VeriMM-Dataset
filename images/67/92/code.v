module top_module (
	input x,
	input y,
	input z,
	output s_sop,
	output s_pos);assign s_sop = (~x & y & ~z) | (~x & ~y & z) | (x & y & ~z);
	assign s_pos = (x | y | ~z) & (~x | ~y | z) & (~x | y | ~z);
endmodule