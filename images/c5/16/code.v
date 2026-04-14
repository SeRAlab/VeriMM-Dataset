module bitwise_logic(
  input in1,
  input in2,
  input in3,
  output out1
);

  wire not_in3;
  wire and_in1_in2;
  wire or_and_not;

  assign not_in3 = ~in3;
  assign and_in1_in2 = in1 & in2;
  assign or_and_not = and_in1_in2 | not_in3;

  assign out1 = or_and_not;

endmodule