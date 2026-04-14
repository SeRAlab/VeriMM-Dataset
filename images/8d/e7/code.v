module top_module(
	output o,
	input a,
	input b
);parameter [3:0] INIT = 4'h0;
	parameter EQN = "(A)";

	wire [1:0] s1 = b ? INIT[ 3:2] : INIT[1:0];
	assign o = a ? s1[1] : s1[0];	
endmodule