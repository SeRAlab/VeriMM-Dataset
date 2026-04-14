module top_module(I0, I1, I2, I3, S, O);input I0, I1, I2, I3, S;
  output O;
  
  wire not_S, sel1, sel2;
  
  assign not_S = ~S;
  assign sel1 = not_S & I0 | S & I1;
  assign sel2 = not_S & I2 | S & I3;
  assign O = sel1 & ~sel2 | sel2 & ~sel1;
  
endmodule