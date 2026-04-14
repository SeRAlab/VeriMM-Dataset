module top_module (
	input l,
	input m,
	input n,
	output v_sop,
	output v_pos);assign v_sop = (~l & ~m & n) | (~l & m & ~n) | (l & m & ~n);
assign v_pos = (l | m | ~n) & (l | ~m | n) & (~l | ~m | n);
endmodule