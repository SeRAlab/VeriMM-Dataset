module top_module(
	output o,
	input a,
	input b,
	input c,
	input d
);parameter [15:0] INIT = 16'h0;
	parameter EQN = "(A)";

	wire [7:0] s3 = d ? INIT[15:8] : INIT[7:0];
	wire [3:0] s2 = c ?   s3[ 7:4] :   s3[3:0];
	wire [1:0] s1 = b ?   s2[ 3:2] :   s2[1:0];
	assign o = a ? s1[1] : s1[0];	
endmodule