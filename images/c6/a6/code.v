module comparator_3bit (
  input [2:0] A,
  input [2:0] B,
  output reg EQ,
  output reg GT,
  output reg LT
);

  // EQ
  assign EQ = ~(A^B);

  // GT
  assign {GT, LT} = {(A>B), (A<B)};

endmodule
