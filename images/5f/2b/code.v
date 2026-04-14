module top_module (
	input p,
	input q,
	input r,
	output h_sop,
	output h_pos);assign h_sop = (~p & q & ~r) | (~p & q & r) | (p & q & r);
	assign h_pos = (p | q | ~r) & (p | ~q | ~r) & (~p | q | r);
endmodule