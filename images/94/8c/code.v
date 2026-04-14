module top_module (
	input p,
	input q,
	input r,
	input s,
	output out_sop,
	output out_pos);assign out_sop = q | r | s;
	assign out_pos = (p | q | r | s) & (~p | q | ~r | s);
endmodule