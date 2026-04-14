module top_module (
	input x,
	input y,
	input z,
	output result_sop,
	output result_pos);assign result_sop = y&z | x&y;
	assign result_pos = (x | ~z) & (~x | y);
endmodule