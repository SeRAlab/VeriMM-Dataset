module top_module(
  input a, b,
  output F3, F2, F1, F0);assign F0 = ~a & ~b;
  assign F1 = ~a & b;
  assign F2 = a & ~b;
  assign F3 = a & b;endmodule