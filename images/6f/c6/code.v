module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n1, n2, n3;

  // Logic for Full Adder using primitive gates
  assign n1 = A ^ B;           // XOR for A and B
  assign S = n1 ^ Ci;          // XOR for sum with carry input
  assign n2 = n1 & Ci;         // AND for first part of carry
  assign n3 = A & B;           // AND for second part of carry
  assign Co = n2 | n3;         // OR for final carry output
endmodule