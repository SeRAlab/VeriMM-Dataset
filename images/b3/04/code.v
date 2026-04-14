module top_module(
  input [n-1:0] data,
  output p,
  output e
);parameter n = 8; // number of data bits

wire parity_bit;
assign parity_bit = ^data; // XOR of all data bits

assign p = parity_bit;
assign e = (parity_bit == 1'b1) ? 1'b1 : 1'b0; // set error flag if parity bit is odd

endmodule