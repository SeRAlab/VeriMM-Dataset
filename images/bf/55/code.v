module top_module(x, s2, cout);input [35:0] x;
  output s2;
  output [17:0] cout;

  assign {s2, cout} = x[17:0] + x[35:18];endmodule