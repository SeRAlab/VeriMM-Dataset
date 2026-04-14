module top_module (
	input a, 
	input b, 
	input c, 
	output reg t);assign t = (a & ~b & c) | (~a & b & c) | (a & b & ~c);
	
endmodule