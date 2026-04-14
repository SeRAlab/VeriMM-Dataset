module top_module(Q0, Q1, Q2, Q3, D, S1, S0);output Q0, Q1, Q2, Q3;
  input D, S1, S0;

  assign Q0 = (!S1 & !S0) ? D : 1'bz;
  assign Q1 = (!S1 & S0) ? D : 1'bz;
  assign Q2 = (S1 & !S0) ? D : 1'bz;
  assign Q3 = (S1 & S0) ? D : 1'bz;
endmodule