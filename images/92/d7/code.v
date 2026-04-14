module top_module(x, int_s1, s, cout);input [6:0]x;
  input [2:0]int_s1;
  output s;
  output [4:0]cout;

  wire [9:0]int_x;
  assign int_x = {x,int_s1};

  assign {s, cout} = int_x[4:0] + int_x[9:5];endmodule