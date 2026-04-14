module top_module(a, y);input [7:0] a;
  output [3:0] y;
  assign y = ~a >> 4;
endmodule