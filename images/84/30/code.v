module top_module(I0, I1, I2, I3, S0, S1, O);input I0, I1, I2, I3, S0, S1;
  output O;
  
  wire w1, w2, w3, w4, w5, w6;
  
  assign w1 = ~S0 & ~S1 & I0;
  assign w2 = ~S0 & S1 & I1;
  assign w3 = S0 & ~S1 & I2;
  assign w4 = S0 & S1 & I3;
  
  assign w5 = w1 | w2;
  assign w6 = w3 | w4;
  
  assign O = w5 | w6;
endmodule