module top_module(
  output Y,
  input S0, S1, A, B, C, D
);assign Y = (S1 & S0) ? D :
             (S1 & ~S0) ? C :
             (~S1 & S0) ? B :
             (~S1 & ~S0) ? A :
             1'bx; // default value

endmodule