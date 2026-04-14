module top_module(
  input signed [31:0] a,
  input signed [31:0] b,
  output signed [31:0] q
);assign q = a - b * (a / b);

endmodule