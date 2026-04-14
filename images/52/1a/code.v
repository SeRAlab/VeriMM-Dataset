module top_module(
  input a,
  input b,
  input c,
  output z
);assign z = (a & b) ^ (c | ~b);

endmodule