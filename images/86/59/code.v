module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire n9, n10, n11;

  // Standard logic gates replacement
  assign n9 = ~(A & B);       // NAND gate equivalent
  assign n11 = ~(A ^ B);      // XNOR gate equivalent (inverse of XOR)
  assign n10 = ~(A & B | Ci); // OAI21 gate equivalent: NOT ((A AND B) OR Ci)

  assign S = ~(Ci ^ n11);     // XNOR gate equivalent
  assign Co = ~(n10 & n9);    // NAND gate equivalent

endmodule