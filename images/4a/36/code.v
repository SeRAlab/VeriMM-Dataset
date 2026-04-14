module top_module(
  input clk,
  input [23:0] rgb_888,
  output [15:0] rgb_565
);assign rgb_565 = {5'b0, rgb_888[7:3], rgb_888[2:0], rgb_888[15:11], rgb_888[10:6], 3'b0};

endmodule