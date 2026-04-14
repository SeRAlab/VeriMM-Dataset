module top_module (
	input d,
	input e,
	input f,
	output p_sop,
	output p_pos);assign p_sop = (~d & e & ~f) | (~d & e & f) | (d & e & f);
	assign p_pos = (d | e | f) & (d | ~e | ~f) & (~d | e | f);
endmodule