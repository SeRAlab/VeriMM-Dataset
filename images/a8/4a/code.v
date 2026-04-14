module top_module(
  input [3:0] x,
  output f
);wire d1, d2, d3, d4;

  assign d1 = x[0] & x[1];
  assign d2 = x[0] & x[2];
  assign d3 = x[1] & x[3];
  assign d4 = x[2] & x[3];

  assign f = d1 | d2 | d3 | d4;
endmodule