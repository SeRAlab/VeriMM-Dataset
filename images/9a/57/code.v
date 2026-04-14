module top_module (
	input a,
	input b,
	input c,
	output f_sop,
	output f_pos);assign f_sop = ~a&~b | ~a&c;
	assign f_pos = (~a | ~b | c) & (~a | b | ~c);
endmodule