module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;
  wire   n1, n2, n3, n4, n5;

  // XOR gates for sum
  assign n1 = A ^ B;      // XOR operation for A and B
  assign S = n1 ^ Ci;     // XOR operation for the sum with carry-in

  // AND gates for carry-out
  assign n2 = A & B;      // AND operation for A and B
  assign n3 = A & Ci;     // AND operation for A and carry-in
  assign n4 = B & Ci;     // AND operation for B and carry-in

  // OR gate for carry-out
  assign Co = n2 | n3 | n4; // OR to find final carry-out
endmodule