module custom_logic_q (
	input a,
	input b,
	input c,
	input d,
	output reg q);

assign q = ~a&~b&~c&d | a&~b&c&d | a&b&~c&d | a&~b&~c&d | ~a&b&~c&~d | ~a&b&c&~d | a&~b&~c&d;

endmodule