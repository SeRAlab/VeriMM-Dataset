module top_module (
	input w,
	input x,
	input y,
	input z,
	output out_sop,
	output out_pos);assign out_sop = w & ~x;
assign out_pos = w & (~x | y | z);
endmodule