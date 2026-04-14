module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n11;

  // Implement S = XNOR(A XOR B, Ci)
  assign S = ~( (A ^ B) ^ Ci );

  // Implement Co = NAND(A, B, Ci)
  assign n11 = ~(A & B & Ci);
  assign Co = n11;

endmodule