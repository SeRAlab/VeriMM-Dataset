module top_module (
	input e,
	input f,
	input g,
	output n_sop,
	output n_pos);assign n_sop = (~e & ~f & ~g) | (~e & f & g) | (e & ~f & g);
	assign n_pos = (e | f | ~g) & (e | ~f | g) & (~e | ~f | g);
endmodule