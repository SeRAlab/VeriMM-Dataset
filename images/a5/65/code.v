module top_module(
  input in,
  output out
);parameter V_CONSTANT = 3.3; // constant voltage value

  assign out = V_CONSTANT; // assign the constant voltage value to the output signal

endmodule