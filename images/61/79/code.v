module top_module(
  input in1,
  input in2,
  output out
);// AND gate
  assign out = in1 & in2;

  // OR gate
  // assign out = in1 | in2;

  // NOT gate
  // assign out = ~in1;

  // XOR gate
  // assign out = in1 ^ in2;

  // XNOR gate
  // assign out = ~(in1 ^ in2);

endmodule