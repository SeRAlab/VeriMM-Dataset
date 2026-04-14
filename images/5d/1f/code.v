module top_module(A, B, left, right);input [63:0] A, B;
	output [63:0] left, right;
	
	assign left = A << B[5:0];
	assign right = A >> B[5:0];endmodule