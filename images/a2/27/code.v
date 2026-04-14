module top_module(
  output reg [3:0] Y,
  input [3:0] A, B, C
);assign Y = (A & ~B & ~C) | (~A & B & ~C) | (~A & ~B & C) | (A & B & C);

endmodule