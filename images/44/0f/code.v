module top_module(
  input [15:0] input_a,
  output [15:0] a_m,
  output [5:0] a_e,
  output a_s);wire [15:0] a;

  assign a = input_a;
  assign a_m[15:5] = {1'b1, a[9 : 0]};
  assign a_m[4:0] = 8'b0;
  assign a_e = a[14 : 10] - 15;
  assign a_s = a[15];endmodule