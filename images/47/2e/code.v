module top_module (
	input x,
	input y,
	input z,
	input w,
	output result_sop,
	output result_pos);assign result_sop = (~x & y & ~z & ~w) | (~x & y & z & ~w) | (x & ~y & z & ~w) | (x & y & ~z & ~w);
assign result_pos = (x | ~y | z | w) & (x | y | ~z | w) & (~x | ~y | z | ~w) & (~x | y | ~z | ~w);
endmodule