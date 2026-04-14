module top_module(
  input [3:0] data,
  output reg parity
);assign parity = ^data; // XOR all bits in data

endmodule