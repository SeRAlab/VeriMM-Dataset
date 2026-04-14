module top_module (
	input p,
	input q,
	output out_sop,
	output out_pos);assign out_sop = p | q;
	assign out_pos = p | q;
endmodule