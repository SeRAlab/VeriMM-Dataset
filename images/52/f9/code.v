module top_module(
  a_i,
  b_i,
  o
);input [23:0] a_i;
  input [23:0] b_i;
  output [47:0] o;
  wire [47:0] o;
  assign o = a_i * b_i;endmodule