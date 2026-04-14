module top_module(
  input in1,
  input in2,
  output out_and,
  output out_or,
  output out_not,
  output out_xor,
  output out_xnor
);// AND gate
  assign out_and = in1 & in2;

  // OR gate
  assign out_or = in1 | in2;

  // NOT gate
  assign out_not = ~in1;

  // XOR gate
  assign out_xor = in1 ^ in2;

  // XNOR gate
  assign out_xnor = ~(in1 ^ in2);

endmodule