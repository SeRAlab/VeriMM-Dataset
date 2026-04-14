module top_module (
	input p,
	input q,
	input r,
	input s,
	output w_sop,
	output w_pos);assign w_sop = (~p & q & r & ~s) | (p & ~q & r & ~s) | (p & q & r & ~s) | (p & q & r & s);
assign w_pos = (p | q | ~r | s) & (p | ~q | ~r | s) & (~p | q | ~r | s) & (~p | ~q | r | ~s);
endmodule