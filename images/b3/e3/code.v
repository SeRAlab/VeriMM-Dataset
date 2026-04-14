module decision_logic (
	input a,
	input b,
	input c,
	input d,
	output reg w);assign w = a&~b&c&d | ~a&b&~c&d | a&b&c&~d | a&~b&~c&~d | a&b&~c&d;

endmodule