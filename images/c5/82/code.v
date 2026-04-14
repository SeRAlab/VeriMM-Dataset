module mux_2to1_enable (
  input A,
  input B,
  input E,
  output Y
);

  assign Y = E ? A : B;

endmodule