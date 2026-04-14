module top_module (
	input e,
	input f,
	input g,
	input h,
	output q_sop,
	output q_pos);assign q_sop = (~e & ~f & ~g & ~h) | (~e & f & ~g & h) | (e & ~f & g & ~h);
assign q_pos = (~e | ~f | ~g | h) & (~e | f | g | ~h) & (e | ~f | g | ~h);
endmodule