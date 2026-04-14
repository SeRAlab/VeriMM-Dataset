module top_module(
  input [15:0] a,
  output reg [31:0] y
);always @(*)
    y = { { 16 { a[15] } }, a};endmodule