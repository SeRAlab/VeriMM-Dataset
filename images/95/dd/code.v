module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;
  wire n9, n10, n11;

  // XNOR gate using basic gates
  assign n11 = ~(A ^ B);
  assign S = ~(Ci ^ n11);  //  Use basic gates to implement XNOR
  assign n10 = ~((A & B) | Ci); // Implementing OAI21
  assign n9 = ~(A & B); // Implementing NAND2
  assign Co = ~(n10 & n9); // Implementing NAND2

endmodule