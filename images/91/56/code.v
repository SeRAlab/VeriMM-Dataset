module top_module(rgb565,
    vga_r,
    vga_g,
    vga_b);input [15:0]rgb565;
  output [3:0]vga_r;
  output [3:0]vga_g;
  output [3:0]vga_b;

  wire [15:0]rgb565;

  assign vga_b[3:0] = rgb565[4:1];
  assign vga_g[3:0] = rgb565[10:7];
  assign vga_r[3:0] = rgb565[15:12];
endmodule