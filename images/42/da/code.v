module top_module (
	input p,
	input q,
	input r,
	output t_sop,
	output t_pos);assign t_sop = (~p & ~q & r) | (p & ~q & r) | (p & q & ~r);
assign t_pos = (p | q | ~r) & (~p | q | r) & (~p | ~q | r);
endmodule