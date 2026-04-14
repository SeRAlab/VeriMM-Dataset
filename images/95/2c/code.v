module top_module(
  A,
  B,
  CIN,
  SUM,
  COUT
);input A;
  input B;
  input CIN;
  output SUM;
  output COUT;
  
  wire w1, w2, w3;
  
  // XOR gate to calculate SUM
  xor(w1, A, B);
  xor(SUM, w1, CIN);
  
  // AND gate to calculate COUT
  and(w2, A, B);
  and(w3, w1, CIN);
  or(COUT, w2, w3);
endmodule