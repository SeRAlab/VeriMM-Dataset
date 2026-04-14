module top_module(
  input signed [n-1:0] in,
  output signed [n-1:0] out
);parameter n = 8; // width of input and output signals

assign out = (in >= 0) ? in : (~in + 1);

endmodule