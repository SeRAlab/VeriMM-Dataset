module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire n1, n2, n3;

  // XOR gates for sum calculation
  assign n1 = A ^ B;
  assign S = n1 ^ Ci;

  // AND gates for carry calculation
  assign n2 = A & B;
  assign n3 = n1 & Ci;

  // OR gate for final carry out
  assign Co = n2 | n3;

endmodule