module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire n9, n10, n11;

  // Replace unknown module types with equivalent primitives
  assign n11 = ~(A ^ B);  // XNOR
  assign S = ~(n11 ^ Ci);  // XNOR
  
  assign n10 = ~(A & B | Ci);  // OAI21
  assign n9 = ~(A & B);  // NAND
  assign Co = ~(n10 & n9);  // NAND
endmodule