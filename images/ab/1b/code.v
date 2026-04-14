module top_module(CLK,RST_N,pixelect,RDY_pixelect,hsync,RDY_hsync,vsync,RDY_vsync,video_en,RDY_video_en,stack_en,RDY_stack_en);input CLK; 
  input RST_N; 
  output [16 : 0] pixelect; 
  output RDY_pixelect; 
  output hsync; 
  output RDY_hsync; 
  output vsync; 
  output RDY_vsync; 
  output video_en; 
  output RDY_video_en; 
  output stack_en; 
  output RDY_stack_en; 
  wire [16 : 0] pixelect; 
  wire RDY_hsync, 
  RDY_pixelect, 
  RDY_stack_en, 
  RDY_video_en, 
  RDY_vsync, 
  hsync, 
  stack_en, 
  video_en, 
  vsync; 
  assign pixelect = 17'd12 ; 
  assign RDY_pixelect = 1'd1 ; 
  assign hsync = 1'd1 ; 
  assign RDY_hsync = 1'd1 ; 
  assign vsync = 1'd1 ; 
  assign RDY_vsync = 1'd1 ; 
  assign video_en = 1'd1 ; 
  assign RDY_video_en = 1'd1 ; 
  assign stack_en = 1'd1 ; 
  assign RDY_stack_en = 1'd1 ; 
 endmodule