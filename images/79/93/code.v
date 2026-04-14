module top_module(A, B, S, C);input [3:0] A, B;
  output [3:0] S;
  output C;
  
  wire c0, c1, c2, c3;
  
  assign c0 = A[0] & B[0];
  assign S[0] = A[0] ^ B[0];
  
  assign c1 = (A[1] & B[1]) | (A[0] & B[1]) | (A[1] & B[0]);
  assign S[1] = (A[1] ^ B[1]) ^ c0;
  
  assign c2 = (A[2] & B[2]) | (A[1] & B[2]) | (A[2] & B[1]) | (A[0] & B[2]) | (A[2] & B[0]) | (A[1] & B[1]);
  assign S[2] = (A[2] ^ B[2]) ^ c1;
  
  assign c3 = (A[3] & B[3]) | (A[2] & B[3]) | (A[3] & B[2]) | (A[1] & B[3]) | (A[3] & B[1]) | (A[2] & B[2]) | (A[0] & B[3]) | (A[3] & B[0]);
  assign S[3] = (A[3] ^ B[3]) ^ c2;
  
  assign C = c3;
endmodule