module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output reg f);assign f = a&~b | c&~d | ~a&d;

endmodule