module top_module (
	input u,
	input v,
	input w,
	output x_sop,
	output x_pos);assign x_sop = (~u & ~v & ~w) | (~u & v & ~w) | (u & ~v & ~w);
assign x_pos = (u | v | w) & (~u | ~v | w) & (~u | v | w);
endmodule