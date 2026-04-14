module top_module(
  input in1,
  input in2,
  output out1
);// Define the product terms as Boolean functions of the input signals
  wire p1 = in1 & in2;
  wire p2 = in1 | in2;

  // Define the sum term as a Boolean function of the product terms
  wire s1 = p1 ^ p2;

  // Connect the inputs to the AND gates
  assign p1 = in1 & in2;
  assign p2 = in1 | in2;

  // Connect the AND gates to the OR gate
  assign out1 = s1;

endmodule