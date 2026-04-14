module top_module(A, B, CIN, S, COUT);input A, B, CIN;
  output S, COUT;

  wire x1, x2, x3, x4;

  assign x1 = A ^ B;
  assign x2 = x1 ^ CIN;
  assign x3 = A & B;
  assign x4 = CIN & x1;

  assign S = x2;
  assign COUT = x3 | x4;

endmodule