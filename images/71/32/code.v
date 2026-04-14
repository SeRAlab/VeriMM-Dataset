module top_module(
  input [n-1:0] bin,
  output [n-1:0] gray
);parameter n = 4; // number of bits in the binary number

assign gray = bin ^ (bin >> 1);

endmodule