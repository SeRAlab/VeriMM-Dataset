module top_module(I, S1, S0, O0, O1, O2, O3);input I, S1, S0;
  output O0, O1, O2, O3;

  wire not_S1, not_S0;

  assign not_S1 = ~S1;
  assign not_S0 = ~S0;

  assign O0 = (not_S1 & not_S0) ? I : 1'bz;
  assign O1 = (not_S1 & S0) ? I : 1'bz;
  assign O2 = (S1 & not_S0) ? I : 1'bz;
  assign O3 = (S1 & S0) ? I : 1'bz;

endmodule