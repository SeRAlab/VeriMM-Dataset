module top_module(clk,
    rgb_565,
    rgb_888);(* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) input clk;
  input [15:0]rgb_565;
  output [23:0]rgb_888;

  wire const0 = 1'b0;
  wire [4:0] r_5 = rgb_565[15:11];
  wire [5:0] g_6 = rgb_565[10:5];
  wire [4:0] b_5 = rgb_565[4:0];

  wire [7:0] r_8 = {r_5, 3'b000};
  wire [7:0] g_8 = {g_6[5:0], 2'b00};
  wire [7:0] b_8 = {b_5, 3'b000};

  assign rgb_888[23:16] = r_8;
  assign rgb_888[15:8] = g_8;
  assign rgb_888[7:0] = b_8;

endmodule