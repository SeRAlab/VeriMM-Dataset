module top_module(x, s, cout);input [6:0]x;
  output s;
  output [2:0]cout;
  
  assign {s, cout} = x[2:0] + x[5:3] + x[6];endmodule