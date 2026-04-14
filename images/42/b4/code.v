module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  
  wire   n1, n2, n3;

  // Calculate sum (S)
  assign n1 = A ^ B;    // XOR
  assign S = n1 ^ Ci;   // XOR with carry-in

  // Calculate carry out (Co)
  assign n2 = A & B;    // AND
  assign n3 = n1 & Ci;  // AND with carry-in
  assign Co = n2 | n3;  // OR for final carry out

endmodule