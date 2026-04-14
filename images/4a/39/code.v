module top_module (
	input p,
	input q,
	input r,
	input s,
	output out_sop,
	output out_pos);assign out_sop = r;
	assign out_pos = (r | s);
endmodule