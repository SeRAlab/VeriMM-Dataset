module top_module (
	input a,
	input b,
	input c,
	output j_sop,
	output j_pos);assign j_sop = (~a & ~b & ~c) | (~a & b & ~c) | (a & ~b & c) | (a & b & c);
assign j_pos = (a | b | ~c) & (a | ~b | c) & (~a | b | c) & (~a | ~b | ~c);
endmodule