module top_module(A, B, Ci, S, Co);input [3:0] A, B;
  input Ci;
  output [3:0] S;
  output Co;

  wire [3:0] x;
  wire c1, c2, c3;

  // First bit
  assign x[0] = A[0] ^ B[0];
  assign c1 = A[0] & B[0];
  assign S[0] = x[0] ^ Ci;
  assign c2 = c1 | Ci;

  // Second bit
  assign x[1] = A[1] ^ B[1];
  assign c1 = A[1] & B[1];
  assign S[1] = x[1] ^ c2;
  assign c3 = x[1] & c2;
  assign c2 = c1 | c3;

  // Third bit
  assign x[2] = A[2] ^ B[2];
  assign c1 = A[2] & B[2];
  assign S[2] = x[2] ^ c2;
  assign c3 = x[2] & c2;
  assign c2 = c1 | c3;

  // Fourth bit
  assign x[3] = A[3] ^ B[3];
  assign c1 = A[3] & B[3];
  assign S[3] = x[3] ^ c2;
  assign c3 = x[3] & c2;
  assign Co = c1 | c3;

endmodule