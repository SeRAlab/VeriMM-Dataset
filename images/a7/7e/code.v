module top_module(clk,
    rgb_565,
    rgb_888);input clk;
  input [15:0]rgb_565;
  output [23:0]rgb_888;

  wire [7:0] red;
  wire [7:0] green;
  wire [7:0] blue;

  assign red = {rgb_565[15:11], 3'b000};
  assign green = {rgb_565[10:5], 2'b00};
  assign blue = {rgb_565[4:0], 3'b000};

  assign rgb_888 = {red, green, blue};

endmodule