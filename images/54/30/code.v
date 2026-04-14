module top_module(
  input [7:0] A,
  input [7:0] B,
  input sel,
  output [7:0] S,
  output [7:0] D
);assign S = A + B;
  assign D = A - B;

  assign S = sel ? D : S;
  assign D = sel ? S : D;

endmodule