module top_module (
	input a, 
	input b, 
	input c,
	output reg z);assign z = (a & b & ~c) | (~a & ~b & c) | (a & b & c);

endmodule