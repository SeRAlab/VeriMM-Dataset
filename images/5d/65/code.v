module top_module(
  input [n-1:0] in,
  input parity,
  output error
);parameter n = 8; // number of input signals

wire parity_check;
assign parity_check = ^in; // XOR gate to compute the parity of the input signals

assign error = (parity_check == parity) ? 0 : 1; // compare the computed parity with the parity signal input

endmodule