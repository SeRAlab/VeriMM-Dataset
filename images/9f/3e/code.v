module top_module (
	input x,
	input y,
	input z,
	input w,
	output l_sop,
	output l_pos);assign l_sop = (~x & y & ~z & ~w) | (~x & y & z & ~w) | (x & ~y & z & ~w) | (x & y & ~z & w);
assign l_pos = (~x | ~y | z | ~w) & (~x | y | z | ~w) & (x | ~y | ~z | w) & (x | y | ~z | ~w);
endmodule