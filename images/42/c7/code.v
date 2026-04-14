module top_module (
	input s,
	input t,
	input u,
	output q_sop,
	output q_pos);assign q_sop = (~s & t & ~u) | (s & ~t & u) | (s & t & ~u);
	assign q_pos = (s | ~t | u) & (s | t | ~u) & (~s | t | ~u);
endmodule