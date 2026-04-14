module top_module(V,A);input [2:0] V;
	output [3:0] A;
	
	assign A[3]=1'b0;
	assign A[2]=V[2]&V[1];
	assign A[1]=~V[1];
	assign A[0]=V[0];endmodule