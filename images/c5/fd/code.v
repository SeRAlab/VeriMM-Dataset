module binary_to_gray(
  input [3:0] A,
  output [3:0] G
);

  assign G[0] = A[0];
  assign G[1] = A[0] ^ A[1];
  assign G[2] = A[1] ^ A[2];
  assign G[3] = A[2] ^ A[3];

endmodule