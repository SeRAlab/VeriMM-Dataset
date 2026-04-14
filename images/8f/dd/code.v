module top_module(output reg o, input i0, i1, i2);wire w1, w2, w3, w4;
  
  assign w1 = i0 & i1;
  assign w2 = i0 & i2;
  assign w3 = i1 & i2;
  assign w4 = w1 | w2 | w3;
  
  assign o = ~w4;
endmodule