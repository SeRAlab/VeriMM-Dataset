module logic_function (A, B, Ci, S, Co);
  input A, B, Ci;
  output S, Co;
  wire   n10, n11, n12;

  // XNOR2_X1 U1 ( .A(Ci), .B(n12), .ZN(S) );
  assign n12 = ~(A ^ B);
  assign S = ~(n12 ^ Ci);

  // NAND2_X1 U3 ( .A1(n11), .A2(n10), .ZN(Co) );
  assign n10 = ~(A & B);
  assign n11 = ~(A & Ci);
  assign Co = ~(n10 & n11);

  // XNOR2_X1 U2 ( .A(B), .B(A), .ZN(n12) );
  // NAND2_X1 U4 ( .A1(A), .A2(B), .ZN(n10) );
  // OAI21_X1 U5 ( .B1(A), .B2(B), .A(Ci), .ZN(n11) );
endmodule