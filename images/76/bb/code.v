module top_module (
	input m,
	input n,
	input o,
	output h_sop,
	output h_pos);assign h_sop = (~m & n & ~o) | (~m & n & o) | (m & ~n & o) | (m & n & o);
assign h_pos = (m | ~n | ~o) & (m | ~n | o) & (m | n | o) & (~m | n | o);
endmodule