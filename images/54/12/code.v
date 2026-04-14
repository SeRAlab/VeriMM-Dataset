module top_module(A, B, EQ, GT, LT);input [3:0] A, B;
output EQ, GT, LT;

// EQ output
assign EQ = (A == B);

// GT output
assign GT = ((A[3] == 0) & (B[3] == 1)) | ((A[3] == B[3]) & (A > B));

// LT output
assign LT = ((A[3] == 1) & (B[3] == 0)) | ((A[3] == B[3]) & (A < B));

endmodule