module MUX_2x1_8(
  input [7:0] A,
  input [7:0] B,
  input SEL,
  output [7:0] X
);

  assign X = SEL ? B : A;

endmodule