module top_module(x,y);input wire[1:0] x;
  output wire[1:0] y;

  assign y = x << 1;endmodule