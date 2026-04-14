module top_module(V,B);input [1:0] V;
	output [3:0] B;
	
	assign B[0]= V[0];
	assign B[1]= ~V[1];
	assign B[2]= ~V[1];
	assign B[3]= V[1];endmodule