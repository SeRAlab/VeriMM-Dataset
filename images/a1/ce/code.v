module top_module(O, I0, I1, S0);input I0,I1;
  input S0;
  output O;
  assign O = S0 ? I1 : I0;endmodule