module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;

  wire AB, ACi, BCi;

  // Sum output: S = A XOR B XOR Ci
  assign S = A ^ B ^ Ci;

  // Carry output: Co = (A AND B) OR (B AND Ci) OR (A AND Ci)
  assign Co = (A & B) | (B & Ci) | (A & Ci);

endmodule