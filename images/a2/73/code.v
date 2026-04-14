module top_module(
  input [15:0] a,
  output [15:0] value,
output z_s);assign value = a[15] ? -a : a;
  assign z_s = a[15];endmodule