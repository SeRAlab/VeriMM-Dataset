module top_module(A, B, S, Cout);input [3:0] A;
  input [3:0] B;
  output [3:0] S;
  output Cout;

  wire c1, c2, c3;

  assign c1 = A[0] & B[0];
  assign c2 = (A[0] ^ B[0]) & (A[1] & B[1]);
  assign c3 = (A[1] ^ B[1]) & (A[2] & B[2]);
  
  assign S[0] = A[0] ^ B[0];
  assign S[1] = (A[1] ^ B[1]) ^ c1;
  assign S[2] = (A[2] ^ B[2]) ^ c2;
  assign S[3] = (A[3] ^ B[3]) ^ c3;
  
  assign Cout = (A[3] & B[3]) | c3;

endmodule