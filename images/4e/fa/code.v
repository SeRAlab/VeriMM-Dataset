module top_module(
  input [15:0] rgb565,
  output [3:0] vga_r,
  output [3:0] vga_g,
  output [3:0] vga_b
);assign vga_r = rgb565[15:11];
  assign vga_g = rgb565[10:6];
  assign vga_b = rgb565[5:1];
  
endmodule