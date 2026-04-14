module top_module(V,A,z,M);input [3:0] V,A;
	input z;
	output [3:0] M;
	assign M[0] = (~z&V[0])|(z&A[0]);
	assign M[1] = (~z&V[1])|(z&A[1]);
	assign M[2] = (~z&V[2])|(z&A[2]);
	assign M[3] = (~z&V[3])|(z&A[3]);endmodule