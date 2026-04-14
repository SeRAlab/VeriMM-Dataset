module bitwise_operator (
  input in1,
  input in2,
  output out_AND,
  output out_OR,
  output out_XOR,
  output out_NOT
);

  assign out_AND = in1 & in2;
  assign out_OR = in1 | in2;
  assign out_XOR = in1 ^ in2;
  assign out_NOT = ~in1;

endmodule