module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;

  wire S1, C1, C2;

  // XOR gate to calculate the sum of A and B
  assign S1 = A ^ B;

  // XOR gate to calculate the sum of S1 and Ci
  assign S = S1 ^ Ci;

  // AND gate to calculate the carry-out value
  assign C1 = A & B;
  assign C2 = S1 & Ci;

  // OR gate to calculate the carry-out
  assign Co = C1 | C2;
endmodule