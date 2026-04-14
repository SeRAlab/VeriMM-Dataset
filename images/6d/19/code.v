module top_module (
	input x,
	input y,
	input z,
	output f_sop,
	output f_pos);assign f_sop = (x & ~y & ~z) | (x & y & ~z) | (~x & y & z);
assign f_pos = (x | y | z) & (x | ~y | z) & (x | ~y | ~z);
endmodule