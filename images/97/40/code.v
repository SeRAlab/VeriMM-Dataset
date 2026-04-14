module top_module(
  input [35:0] in,
  output [35:0] out
);parameter CONSTANT_VALUE = 36'h0000FFFFF;

  assign out = in & CONSTANT_VALUE;

endmodule