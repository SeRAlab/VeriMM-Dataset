module top_module(A, B, Cin, S, Cout);input A, B, Cin;
  output S, Cout;
  wire n1, n2, n3;

  // Logic for Full Adder
  assign n1 = A ^ B;    // XOR for A and B
  assign S = n1 ^ Cin;  // XOR for sum with Cin
  assign n2 = A & B;    // AND for A and B
  assign n3 = n1 & Cin; // AND for n1 and Cin
  assign Cout = n2 | n3; // OR for Cout

endmodule