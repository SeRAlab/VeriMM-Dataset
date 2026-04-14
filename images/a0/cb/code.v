module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n9, n10, n11;

  // Logic definitions for required gates
  wire not_a, not_b, not_ci;

  // Implementation of the gates
  assign n9 = ~(A & B); // NAND2
  assign not_a = ~(A & A); // NOT Gate (A)
  assign not_b = ~(B & B); // NOT Gate (B)
  assign not_ci = ~(Ci & Ci); // NOT Gate (Ci)

  assign n10 = ~(A & B | Ci); // OAI21 implementation
  assign Co = ~(n10 & n9); // NAND2 implementation
  assign n11 = ~(A ^ B); // XNOR2 (A XNOR B)
  assign S = ~(not_ci ^ n11); // XNOR2 (Ci XNOR n11)

endmodule