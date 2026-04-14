module MUX_2_TO_1
(
  input A,
  input B,
  input S,
  output Z
);

  assign Z = (S == 0) ? A : B;

endmodule