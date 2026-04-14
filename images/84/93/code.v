module top_module (
	input x,
	input y,
	input z,
	input w,
	output k_sop,
	output k_pos);assign k_sop = (~x & y & ~z & w) | (x & ~y & z & ~w) | (x & y & ~z & w) | (~x & y & z & ~w);
assign k_pos = (x | ~y | z | w) & (x | y | z | ~w) & (~x | y | ~z | ~w) & (~x | y | z | ~w);
endmodule