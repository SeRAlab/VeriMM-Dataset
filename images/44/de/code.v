module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire   n1, n2, n3, n4;

  // Logic for sum (S)
  assign n1 = A ^ B; // n1 = A XOR B
  assign n2 = n1 ^ Ci; // S = (A XOR B) XOR Ci
  assign S = n2;

  // Logic for carry out (Co)
  assign n3 = A & B; // n3 = A AND B
  assign n4 = n1 & Ci; // n4 = (A XOR B) AND Ci
  assign Co = n3 | n4; // Co = (A AND B) OR ((A XOR B) AND Ci)
endmodule