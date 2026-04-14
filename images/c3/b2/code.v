module mux_2to1 (
  input A0,
  input A1,
  input S,
  output X
);

  // select A0 if S is 0, A1 if S is 1
  assign X = (!S) ? A0 : A1;

endmodule