module top_module (
	input a,
	input b,
	input c,
	input d,
	output s_sop,
	output s_pos);assign s_sop = (~a & b & c & ~d) | (a & ~b & c & d) | (a & b & c & ~d);
assign s_pos = (~a | b | ~c | d) & (a | ~b | c | ~d) & (a | b | c | ~d);
endmodule