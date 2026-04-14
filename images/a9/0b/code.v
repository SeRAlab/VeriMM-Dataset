module top_module (
	input x,
	input y,
	input z,
	input w,
	output e_sop,
	output e_pos);assign e_sop = (~x & ~y & ~z & ~w) | (~x & y & ~z & ~w) | (x & y & ~z & ~w) | (x & y & z & ~w);
assign e_pos = (x | y | z | w) & (x | ~y | z | w) & (~x | y | z | ~w) & (~x | y | ~z | w);
endmodule