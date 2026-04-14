module top_module(A, B, Ci, Co, S);input A, B, Ci;
  output S, Co;
  wire n1, n2, n3;

  // Using primitive gates instead of missing modules
  assign n1 = A ^ B;        // XOR gate for A and B
  assign S = n1 ^ Ci;       // XOR gate for n1 and Ci
  assign n2 = A & B;        // AND gate for A and B
  assign n3 = n1 & Ci;      // AND gate for n1 and Ci
  assign Co = n2 | n3;      // OR gate for n2 and n3

endmodule