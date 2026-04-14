module top_module (
	input a,
	input b,
	input c,
	output out_sop,
	output out_pos);assign out_sop = (~a & ~b & c) | (~a & b & ~c) | (a & ~b & c) | (a & b & c);
assign out_pos = (a | b | ~c) & (~a | ~b | c) & (~a | b | ~c);
endmodule