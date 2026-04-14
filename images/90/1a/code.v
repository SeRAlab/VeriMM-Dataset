module top_module (
	input p,
	input q,
	input r,
	input s,
	output g_sop,
	output g_pos);assign g_sop = (~p & q & ~r & s) | (p & ~q & r & ~s) | (p & q & ~r & ~s);
assign g_pos = (p | ~q | r | s) & (p | q | r | ~s) & (~p | ~q | r | s) & (~p | q | ~r | s);
endmodule