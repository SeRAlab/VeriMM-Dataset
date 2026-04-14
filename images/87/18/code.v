module top_module(a, b, c, y1);input [3:0] a;
  input [3:0] b;
  input [3:0] c;

  
  output [3:0] y1;

  assign y1 = ((a | ~c) & ~b) | b | a;

endmodule