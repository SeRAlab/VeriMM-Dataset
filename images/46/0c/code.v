module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;
  wire w1, w2, w3;

  assign w1 = A ^ B;          // XOR gate for A and B
  assign S = w1 ^ Ci;        // XOR gate for w1 and Ci
  assign w2 = A & B;         // AND gate for A and B
  assign w3 = w1 & Ci;       // AND gate for w1 and Ci
  assign Co = w2 | w3;       // OR gate for w2 and w3
endmodule