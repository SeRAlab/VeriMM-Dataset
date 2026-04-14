module top_module (
	input j,
	input k,
	input l,
	input m,
	output out_sop,
	output out_pos);assign out_sop = (~j & ~k & ~l & ~m) | (~j & ~k & l & ~m) | (j & k & l & m);
assign out_pos = (j | k | l | m) & (~j | ~k | ~l | ~m);
endmodule