module top_module(A, B, C_in, S, C_out);input [3:0] A;
  input [3:0] B;
  input C_in;
  output [3:0] S;
  output C_out;

  wire c1, c2, c3;

  assign c1 = A[0] & B[0];
  assign c2 = A[0] | B[0];
  assign S[0] = A[0] ^ B[0] ^ C_in;
  assign c3 = A[1] & B[1];
  assign S[1] = A[1] ^ B[1] ^ c1;
  assign c1 = c1 | c3;
  assign c3 = A[2] & B[2];
  assign S[2] = A[2] ^ B[2] ^ c2;
  assign c2 = c2 | c3;
  assign c3 = A[3] & B[3];
  assign S[3] = A[3] ^ B[3] ^ c1;
  assign C_out = c2 | c3;

endmodule