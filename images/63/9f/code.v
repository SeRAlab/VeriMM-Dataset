module top_module(I0, I1, I2, I3, S0, S1, O);input I0, I1, I2, I3, S0, S1;
  output O;
  
  wire w1, w2, w3;
  
  // AND gates for S0 and S1
  assign w1 = S0 & S1;   // Corrected assignment
  assign w2 = ~S0 & S1;  // Corrected assignment
  assign w3 = S0 & ~S1;  // Corrected assignment
  
  // OR gates for inputs and AND gates
  assign O = (w1 & I3) | (w2 & I2) | (w3 & I1) | I0; // Corrected assignment
endmodule