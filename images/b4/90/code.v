module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;
  wire n1, n2, n3, n4, n5;

  assign n1 = ~(A ^ B);
  assign n2 = ~(n1 ^ Ci);
  assign n3 = ~(A & B);
  assign n4 = ~(Ci & n1);
  assign n5 = ~(n2 & n3);

  assign S = n5;
  assign Co = n4;

endmodule