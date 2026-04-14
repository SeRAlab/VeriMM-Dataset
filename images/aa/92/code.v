module boolean_logic (
	input a,
	input b,
	input c,
	input d,
	output reg u);assign u = a&~b&c&~d | ~a&b&~c&d | a&b&c&d | ~a&~b&c&d | a&b&~c&~d;

endmodule