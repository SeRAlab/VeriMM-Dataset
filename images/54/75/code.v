module top_module(rgb_888,rgb_565);input [23:0]rgb_888; 
  output [15:0]rgb_565; 
  wire [23:0]rgb_888; 
  assign rgb_565[15:11] = rgb_888[23:19]; 
  assign rgb_565[10:5] = rgb_888[15:10]; 
  assign rgb_565[4:0] = rgb_888[7:3]; 
 endmodule