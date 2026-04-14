module top_module(
  input A,
  input B,
  input S,
  output MO
);assign MO = (S == 1'b1) ? B : A;

endmodule