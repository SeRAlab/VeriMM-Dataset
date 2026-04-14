module top_module (
	input d,
	input e,
	input f,
	output out_sop,
	output out_pos);assign out_sop = (~d & ~e & ~f) | (d & ~e & ~f) | (d & e & ~f) | (d & e & f);
assign out_pos = (~d | e | f) & (d | ~e | f) & (d | e | ~f);
endmodule