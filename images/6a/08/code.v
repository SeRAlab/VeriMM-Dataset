module top_module(
  input [3:0] a,
  output [1:0] r
);parameter constant = 2;

  assign r = a + constant;

endmodule