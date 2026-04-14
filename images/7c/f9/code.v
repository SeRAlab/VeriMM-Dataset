module top_module(
  input wire A, B, C,
  output reg F
);// Minimized Boolean expression: F = A'B' + AB' + BC
  assign F = (~A & ~B) | (A & ~B) | (B & C);

endmodule