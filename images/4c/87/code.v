module top_module(
  input in1,
  input in2,
  input in,
  output out_AND,
  output out_OR,
  output out_NOT,
  output out_XOR,
  output out_XNOR
);assign out_AND = in1 & in2;
  assign out_OR = in1 | in2;
  assign out_NOT = ~in;
  assign out_XOR = in1 ^ in2;
  assign out_XNOR = ~(in1 ^ in2);

endmodule