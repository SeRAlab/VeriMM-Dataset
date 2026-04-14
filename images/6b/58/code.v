module top_module(
  input in1,
  input in2,
  input in3,
  input in4,
  output out
);// Majority gate
  wire majority = (in1 & in2 & in3) | (in1 & in2 & in4) | (in1 & in3 & in4) | (in2 & in3 & in4);

  // Parity gate
  wire parity = in1 ^ in2 ^ in3 ^ in4;

  // XOR gate
  assign out = majority ^ parity;

endmodule