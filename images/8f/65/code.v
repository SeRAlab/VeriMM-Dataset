module top_module (
	input a,
	input b,
	input c,
	input d,
	output p_sop,
	output p_pos);assign p_sop = (a & ~b & c & ~d) | (a & b & c & d) | (~a & b & c & d);
assign p_pos = (~a | b | ~c | ~d) & (a | b | c | d) & (~a | ~b | c | d);
endmodule