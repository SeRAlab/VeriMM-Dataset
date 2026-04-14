module BOOL_EXP (
  input A,
  input B,
  output OUT
);

  wire a_and_not_b_or_a = A & ~(B | A);
  wire not_a_and_b = ~A & B;
  
  assign OUT = a_and_not_b_or_a | not_a_and_b;

endmodule