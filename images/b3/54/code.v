module top_module (
	input p,
	input q,
	input r,
	input s,
	output r_sop,
	output r_pos);assign r_sop = (~p & ~q & ~r & s) | (~p & q & r & s) | (p & ~q & r & s);
assign r_pos = (~p | ~q | r | s) & (p | ~q | ~r | s) & (~p | q | ~r | s);
endmodule