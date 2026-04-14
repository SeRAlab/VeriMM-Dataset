module top_module(
  input G, D,
  output F
);assign F = ~G | D;

endmodule