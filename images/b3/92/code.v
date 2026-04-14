module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire n9, n10, n11;

  assign n11 = ~(A ^ B);        // XNOR implementation
  assign S = ~(Ci ^ n11);       // XNOR implementation for S
  assign n10 = ~(A & B) | Ci;   // OAI21 implementation
  assign n9 = A & B;            // NAND implementation
  assign Co = ~(n10 & n9);      // NAND implementation for Co
endmodule