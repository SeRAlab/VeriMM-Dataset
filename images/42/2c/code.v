module top_module(
  input [n-1:0] in,
  output p,
  output [n-1:0] out
);parameter n = 8; // number of input signals

// Compute the parity bit as a Boolean function of the input signals
wire parity_bit = ^in;

// Output the parity bit and the input signals
assign p = parity_bit;
assign out = in;

endmodule