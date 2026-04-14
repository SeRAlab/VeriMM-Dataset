module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;

  wire   S1, S2, C1, C2;

  // Calculate the sum of the two binary digits
  assign S1 = A ^ B;      // XNOR2 is replaced by XOR
  assign S = S1 ^ Ci;     // Calculate sum with carry-in

  // Calculate the carry-out bit
  assign C1 = A & B;      // NAND2 is replaced by AND
  assign C2 = S1 & Ci;    // Calculate carry with carry-in
  assign Co = C1 | C2;    // Co is the OR of both carry calculations

endmodule