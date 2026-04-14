module top_module (
	input a,
	input b,
	input c,
	output m_sop,
	output m_pos);assign m_sop = (~a & b & c) | (a & ~b & c) | (a & b & ~c);
assign m_pos = (a | ~b | c) & (a | b | ~c) & (~a | b | c);
endmodule