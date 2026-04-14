module top_module (
	input x,
	input y,
	input z,
	output out_sop,
	output out_pos);assign out_sop = (~x & y & ~z) | (~x & y & z) | (x & y & ~z) | (x & y & z);
assign out_pos = (~x | ~y | ~z) & (~x | ~y | z) & (~x | y | z);
endmodule