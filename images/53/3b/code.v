module top_module(
  input A,
  input B,
  output Y0,
  output Y1,
  output Y2,
  output Y3
);assign Y0 = ~(A | B);
  assign Y1 = ~(A | ~B);
  assign Y2 = ~(~A | B);
  assign Y3 = ~(~A | ~B);

endmodule