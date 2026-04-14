module top_module(a2, a1, a0, s, b);parameter n=3;
	input [n-1:0] a2, a1, a0;
	input [2:0] s;
	output [n-1:0] b;

	assign b = ({n{s[0]}} & a0) | 
				  ({n{s[1]}} & a1) |
				  ({n{s[2]}} & a2);endmodule