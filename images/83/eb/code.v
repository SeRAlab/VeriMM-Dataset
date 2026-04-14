module top_module(
  input  A,
  input  B,
  input  C,
  input  VPWR,
  input  VGND,
  input  VPB,
  input  VNB,
  output X
);wire notA, notB, notC;
  wire and1_out, and2_out, not_and3;
  wire or1_out, and3_out, and4_out, and5_out;

  // Invert A, B, C signals
  not u_notA (notA, A);
  not u_notB (notB, B);
  not u_notC (notC, C);

  // Implement the XNOR gate
  and u_and1 (and1_out, A, B);
  and u_and2 (and2_out, notA, notB);
  or  u_or1  (or1_out, and1_out, and2_out);

  and u_and3 (and3_out, or1_out, C);
  not u_not_and3 (not_and3, and3_out);

  and u_and4 (and4_out, VPWR, VGND);
  and u_and5 (and5_out, VPB, VNB);

  // Add power-good signal to output
  or u_or2 (X, and4_out, and5_out);

endmodule