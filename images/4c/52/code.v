module top_module (
	input m,
	input n,
	input o,
	input p,
	output m_sop,
	output m_pos);assign m_sop = (~m & ~n & ~o & p) | (~m & n & o & p) | (m & ~n & o & ~p) | (m & n & ~o & p);
assign m_pos = (m | ~n | ~o | p) & (m | n | ~o | p) & (m | ~n | o | ~p) & (~m | ~n | o | p);
endmodule