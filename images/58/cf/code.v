module top_module(
  input [3:0] A,
  input [3:0] B,
  input RST,
  output [3:0] S,
  output C_out
);assign S = A + B;
  assign C_out = (A[3] & B[3]) | (A[3] & ~S[3]) | (B[3] & ~S[3]);

  // Reset logic
  assign S = RST ? 4'b0000 : S;
  assign C_out = RST ? 1'b0 : C_out;

endmodule