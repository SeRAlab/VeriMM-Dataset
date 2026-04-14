module top_module(A, out);input [0:3]A;     
	output [0:6]out;  

	
	assign	out[0] = ( A[1] & A[3] ) | ( ~A[1] & ~A[3] ) | A[0] | A[2];
	assign 	out[1] = ( A[2] & A[3] ) | ( ~A[2] & ~A[3] ) | (~A[1]);
	assign	out[2] = A[1] | (~A[2]) | A[3];
	assign	out[3] = A[0] | ( ~A[1] & ~A[3] ) | ( A[2] & ~A[3] ) | ( ~A[1] & A[2] ) | ( A[3] & A[1] & (~A[2]) );
	assign	out[4] = ( ~A[1] & ~A[3] ) | ( A[2] & ~A[3] );
	assign	out[5] = A[0] | ( ~A[2] & ~A[3] ) | ( A[1] & ~A[2] ) | ( A[1] & ~A[3] );
	assign	out[6] = ( ~A[1] & A[2] ) | ( A[2] & ~A[3]) | ( A[1] & ~ A[2]) | A[0];endmodule