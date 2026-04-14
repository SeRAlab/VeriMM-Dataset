module top_module(G1, G2, R1, R2);output G1, G2;
  input R1, R2;

  wire R1_inv, R2_inv;

  // Invert the R1 and R2 signals
  not U0 (R1_inv, R1);
  not U1 (R2_inv, R2);

  // AND the inverted signals together
  and U2 (G1, R1_inv, R2);
  and U3 (G2, R2_inv, R1);
endmodule