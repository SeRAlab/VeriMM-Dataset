module top_module (
	input a,
	input b,
	input c,
	input d,
	output r_sop,
	output r_pos);assign r_sop = (~a & b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & d) | (a & b & c & d);
assign r_pos = (a | ~b | c | d) & (~a | b | c | ~d) & (~a | ~b | ~c | d) & (a | b | c | d);
endmodule