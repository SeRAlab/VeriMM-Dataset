module top_module(
  input [n-1:0] data_in,
  input [n-1:0] key,
  output [n-1:0] data_out
);parameter n = 8; // number of bits in data input/output

assign data_out = data_in ^ key;

endmodule