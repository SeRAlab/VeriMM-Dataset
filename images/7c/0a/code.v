module top_module (
	input a, 
	input b, 
	input c, 
	input d,
	output reg y);assign y = (a & d) | (~a & b & ~d) | (a & ~b & d) | (~a & b & c);

endmodule