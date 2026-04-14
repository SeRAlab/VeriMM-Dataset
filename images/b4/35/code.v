module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11;

  wire ab_xnor, ci_xnor; // Temporary wires for XNOR outputs

  // Replacing XNOR2_X1 with the equivalent logic
  assign ab_xnor = ~(A ^ B);
  assign n11 = ab_xnor; 
  assign ci_xnor = ~(Ci ^ n11);
  assign S = ci_xnor;

  // Replacing OAI21 and NAND gates with equivalent logic
  assign n10 = ~(A & B | Ci); // OAI behavior
  
  assign n9 = ~(A & B); // NAND2
  assign Co = ~(n10 & n9); // Combine results for Co

  assign n1 = ~(Ci & n11); // NAND
  assign n2 = ~(B & n11); // NAND
  assign n3 = ~(A & Ci); // NAND
  assign n4 = ~(n1 & n2); // NAND
  assign n5 = ~(n3 & n9); // NAND
  assign n6 = ~(n3 & n2); // NAND
  assign n7 = ~(n1 & n9); // NAND
  assign n8 = ~(n6 & n7); // NAND
  assign Co = ~(n5 & n4); // Final Co

endmodule