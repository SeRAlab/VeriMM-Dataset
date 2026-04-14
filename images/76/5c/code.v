module top_module(x, s, cout);input [32:0] x;
  output s;
  output [15:0] cout;

  assign {s, cout} = x[15:0] + x[31:16] + x[32];endmodule