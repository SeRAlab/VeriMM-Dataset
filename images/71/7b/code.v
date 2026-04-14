module top_module(
  input A,
  input B,
  input S,
  output Z
);assign Z = (S == 0) ? A : B;

endmodule