module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output reg k);assign k = a | ~b^c | ~a&~d;

endmodule