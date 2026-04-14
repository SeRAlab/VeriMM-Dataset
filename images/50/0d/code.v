module top_module (
	input m,
	input n,
	input o,
	output out_sop,
	output out_pos);assign out_sop = (~m & ~n & ~o) | (~m & ~n & o) | (~m & n & o) | (m & n & o);
assign out_pos = (m | n | ~o) & (m | ~n | o) & (~m | n | o);
endmodule