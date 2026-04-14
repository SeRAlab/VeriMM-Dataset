module top_module(
  input X0,
  input X1,
  input X2,
  input X3,
  input S0,
  input S1,
  output Y
);assign Y = (S1 & S0) ? X3 :
             (S1 & ~S0) ? X2 :
             (~S1 & S0) ? X1 :
             X0;

endmodule