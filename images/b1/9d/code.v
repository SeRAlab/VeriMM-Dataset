module top_module(A, B);input [3:0] A;
	output [1:0] B ;
	
	assign B[0] = A[1] | A[3];
	assign B[1] = A[2] | A[3];
	
endmodule