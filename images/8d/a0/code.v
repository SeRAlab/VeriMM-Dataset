module top_module(x, s, cout);input [66:0]x;
  output s;
  output [32:0]cout;

  assign {s, cout} = x[32:0] + x[65:33] + x[66];endmodule