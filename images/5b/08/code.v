module top_module (
	input m,
	input n,
	input o,
	output k_sop,
	output k_pos);assign k_sop = (~m & n & ~o) | (m & ~n & ~o) | (m & ~n & o);
assign k_pos = (m | ~n | o) & (~m | n | ~o) & (~m | n | o);
endmodule