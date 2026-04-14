module top_module (
	input a,
	input b,
	input c,
	input d,
	output reg e);assign e = ((a | b | c) & d);
endmodule