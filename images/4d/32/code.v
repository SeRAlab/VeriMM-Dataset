module top_module(
  input wire A, B, C, D,
  output reg F
);// Simplified Boolean expression
  assign F = !A && (B || C);

endmodule