module top_module (
	input a,
	input b,
	input c,
	output y_sop,
	output y_pos);assign y_sop = (~a & b & ~c) | (a & ~b & c) | (a & b & c);
assign y_pos = (a | ~b | c) & (~a | b | c) & (a | b | ~c);
endmodule