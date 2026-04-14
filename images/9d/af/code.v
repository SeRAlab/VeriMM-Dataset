module top_module(I0, I1, I2, I3, Sel0, Sel1, O);input I0, I1, I2, I3, Sel0, Sel1;
  output O;

  assign O = (Sel0 & Sel1) ? I3 : (Sel0 & ~Sel1) ? I2 : (~Sel0 & Sel1) ? I1 : I0;

endmodule