module top_module(Z, A, B);output Z;
  input A, B;
  wire nA, nA_B, A_nA_B, nA_nA_B;
  
  // Using built-in NOT and AND gates instead of p_not and p_and
  assign nA = ~A;          // Inverting A
  assign nA_B = nA & B;   // nA AND B
  assign A_nA_B = A & nA_B; // A AND (nA AND B)
  assign nA_nA_B = ~A_nA_B; // Inverting (A AND (nA AND B))
  assign Z = A & nA_nA_B;  // Z = A AND (nA_nA_B)

endmodule