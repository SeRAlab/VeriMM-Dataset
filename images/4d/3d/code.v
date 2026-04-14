module top_module (
	input u,
	input v,
	input w,
	input x,
	output out_sop,
	output out_pos);assign out_sop = (~u & ~v & ~w & x) | (~u & ~v & w & x) | (~u & v & ~w & ~x) | (~u & v & ~w & x) | (~u & v & w & x) | (u & v & w & x);
assign out_pos = (u | v | w | x) & (~u | v | ~w | x) & (~u | v | w | ~x) & (u | ~v | ~w | x) & (u | v | ~w | ~x);
endmodule