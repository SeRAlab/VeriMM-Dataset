module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n1, n2, n3, n4;

  // Logic for the Full Adder Implementation
  assign n1 = A ^ B ^ Ci; // Sum output
  assign Co = (A & B) | (B & Ci) | (A & Ci); // Carry output
  assign S = n1; // Connecting Sum

endmodule