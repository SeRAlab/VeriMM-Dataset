module mux_2to1(
  input A,
  input B,
  input S,
  output Y
);

wire not_S, A_and_not_S, B_and_S;

not (
  not_S,
  S
);

and (
  A_and_not_S,
  A,
  not_S
);

and (
  B_and_S,
  B,
  S
);

or (
  Y,
  A_and_not_S,
  B_and_S
);

endmodule