module top_module (
	input p,
	input q,
	input r,
	output l_sop,
	output l_pos);assign l_sop = (~p & q & ~r) | (p & ~q & r) | (p & q & ~r) | (p & q & r);
assign l_pos = (p | ~q | r) & (p | q | ~r) & (~p | ~q | r) & (~p | q | ~r);
endmodule