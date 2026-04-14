module top_module(
  input [n-1:0] d,
  output p,
  output e
);parameter n = 8; // number of data bits

// Parity Generator
assign p = ^d;

// Parity Checker
assign e = (^d) ^ p;

endmodule