module top_module(A,D,En);input [0:1]A;
input En;
output [0:3]D;
assign D[0] = En &  ~A[0] & ~A[1];
assign D[1] = En &  ~A[0] & A[1];
assign D[2] = En &  A[0] & ~A[1];
assign D[3] = En &  A[0] & A[1];endmodule