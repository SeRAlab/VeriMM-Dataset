module top_module(input wire clk,input wire rst,input wire [9:0] hcount_in,input wire hsync_in,input wire [9:0] vcount_in,input wire vsync_in,input wire [23:0] rgb_in,input wire blnk_in,input wire [7:0] char_pixels,output reg [9:0] hcount_out,output reg hsync_out,output reg [9:0] vcount_out,output reg vsync_out,output reg [23:0] rgb_out,output reg blnk_out,output reg [7:0] char_xy,output reg [3:0] char_line);reg [23:0] rgb_nxt; 
  localparam XPOS = 40; 
  localparam YPOS = 50; 
  localparam WIDTH = 552; 
  localparam HEIGHT = 16; 
  always @(posedge clk or posedge rst) begin 
  if(rst) begin 
  hcount_out <= #1 0; 
  vcount_out <= #1 0; 
  hsync_out <= #1 0; 
  vsync_out <= #1 0; 
  rgb_out <= #1 0; 
  blnk_out <= #1 0; 
  end 
  else begin 
  hcount_out <= #1 hcount_in; 
  vcount_out <= #1 vcount_in; 
  hsync_out <= #1 hsync_in; 
  vsync_out <= #1 vsync_in; 
  rgb_out <= #1 rgb_nxt; 
  blnk_out <= #1 blnk_in; 
  end 
  end 
  always @* begin 
  if ((hcount_in >= XPOS) && (hcount_in < XPOS + WIDTH) && (vcount_in >= YPOS) && (vcount_in < YPOS + HEIGHT) && (char_pixels[(XPOS - hcount_in)])) 
  begin 
  if(char_xy == 8'h20) 
  rgb_nxt = 24'hff_ff_00; 
  else 
  rgb_nxt = 24'hff_ff_ff; 
  end 
  else begin 
  rgb_nxt = rgb_in; 
  end 
  end 
  always @* begin 
  char_xy = (hcount_in - XPOS - 1)>>3; 
  end 
  always @* begin 
  char_line = vcount_in - YPOS; 
  end 
 endmodule