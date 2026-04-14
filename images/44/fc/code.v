module top_module (
	input a, 
	input b, 
	input c, 
	output reg y);assign y = (a & ~b & c) | (~a & b & c) | (a & b & ~c);
	
endmodule