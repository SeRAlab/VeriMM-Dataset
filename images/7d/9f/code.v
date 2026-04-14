module top_module (
	input e,
	input f,
	input g,
	input h,
	output i_sop,
	output i_pos);assign i_sop = (~e & ~f & ~g & h) | (~e & f & ~g & ~h) | (~e & f & g & h) | (e & ~f & g & ~h);
assign i_pos = (e | f | g | ~h) & (e | f | ~g | h) & (~e | f | ~g | h) & (~e | ~f | ~g | h);
endmodule