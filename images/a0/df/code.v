module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;

  wire AxorB, AandB;

  // XOR gate to calculate sum
  assign AxorB = A ^ B; // Replace XOR2_X1 with bitwise XOR
  assign S = AxorB ^ Ci; // Include carry-in for sum calculation

  // AND gates to calculate carry-out
  assign AandB = A & B; // Replace AND2_X1 with bitwise AND
  assign Co = AandB | (AxorB & Ci); // Combine to get final carry-out

endmodule