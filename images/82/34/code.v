module top_module(x, y, s, cout);parameter N = 64;
  input [N-1:0]x;
  input [N-1:0]y;
  output s;
  output [N-1:0]cout;

  assign {s,cout} = x + y;endmodule