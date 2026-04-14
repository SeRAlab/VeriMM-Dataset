module top_module(
  input A,
  input B,
  input E,
  output Y
);assign Y = E ? A : B;

endmodule