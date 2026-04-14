module top_module(
  input [n-1:0] bin,
  output [n-1:0] gray
);parameter n = 4; // number of input bits

assign gray = bin ^ {bin[n-1], bin[n-2:1]};

endmodule