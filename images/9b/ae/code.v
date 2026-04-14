module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n1, n2, n3;

  // Using built-in operators to implement the full adder logic
  assign n1 = A ^ B;        // XOR for A and B
  assign n2 = n1 ^ Ci;      // XOR for n1 and Ci (Sum)
  assign n3 = A & B;        // AND for A and B
  assign Co = n3 | (n1 & Ci); // Carry out logic
  assign S = n2;            // Assign sum directly

endmodule