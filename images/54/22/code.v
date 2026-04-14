module top_module(subout,X,Y);input [15:0] X,Y;
  output reg [15:0] subout;
  always@(*)
    subout = X-Y;endmodule