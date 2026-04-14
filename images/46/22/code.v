module top_module (
	input p,
	input q,
	input r,
	output g_sop,
	output g_pos);assign g_sop = (~p & q & ~r) | (p & ~q & ~r) | (p & q & ~r);
assign g_pos = (p | ~q | r) & (p | ~q | ~r) & (~p | q | ~r);
endmodule