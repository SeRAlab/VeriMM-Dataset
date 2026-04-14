module top_module(
  input [3:0] A,
  input [3:0] B,
  input MODE,
  output [3:0] RESULT,
  output COUT,
  output BOUT
);wire [3:0] B_inv;
  wire [3:0] B_neg;
  wire [3:0] C_inv;
  wire [3:0] C_neg;

  assign B_inv = ~B;
  assign B_neg = B_inv + 1;

  assign C_inv = ~MODE;
  assign C_neg = C_inv + 1;

  assign RESULT = A + (B * C_inv) + (B_neg * C_neg);
  assign COUT = (A[3] & B[3]) | (B[3] & ~RESULT[3]) | (A[3] & ~RESULT[3]);
  assign BOUT = (~A[3] & B[3]) | (RESULT[3] & ~B[3]) | (A[3] & RESULT[3]);

endmodule