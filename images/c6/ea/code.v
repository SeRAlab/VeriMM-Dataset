module mux2to1(
  input A,
  input B,
  input S,
  output Y
);

  assign Y = (S == 0) ? A : B;

endmodule