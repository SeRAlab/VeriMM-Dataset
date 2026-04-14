module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;
  wire n1, n2, n3, n4, n5, n6, n7, n8;

  // Corrected logic using standard gates
  assign n1 = A ^ B;       // XOR for A and B
  assign S = n1 ^ Ci;      // XOR for the sum
  assign n2 = A & B;       // AND for A and B
  assign n3 = n1 & Ci;     // AND for interim sum and Ci
  assign Co = n2 | n3;     // OR for carry output

endmodule