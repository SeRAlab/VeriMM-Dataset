module top_module (
	input a, 
	input b, 
	input d, 
	input e,
	output reg c);assign c = a&~b | d&~e | ~a&e;

endmodule