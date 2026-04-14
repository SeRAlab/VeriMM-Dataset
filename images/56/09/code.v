module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n9, n10, n11;

  // S = XNOR(A, B) XNOR Ci
  assign n11 = ~(A ^ B); // XNOR implemented using NOT and XOR
  assign S = ~(n11 ^ Ci); // XNOR implemented again

  // Co = NAND(A, B) AND NOT(S)
  assign n9 = ~(A & B); // NAND implemented using NOT and AND
  assign n10 = (A & B & Ci); // AND for OAI21 logic
  assign Co = ~(n9 & ~(S)); // NAND of result

endmodule