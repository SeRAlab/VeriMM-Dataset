module top_module(
	input a,
	input b,
	output reg y);assign y = (a & ~b) | (~a & b);

endmodule