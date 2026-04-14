module top_module (
	input p,
	input q,
	input r,
	input s,
	output o_sop,
	output o_pos);assign o_sop = (~p & ~q & r & ~s) | (~p & q & ~r & ~s) | (p & ~q & ~r & s) | (p & q & ~r & ~s);
assign o_pos = (p | q | ~r | ~s) & (p | ~q | r | s) & (~p | q | r | ~s) & (~p | ~q | r | ~s);
endmodule