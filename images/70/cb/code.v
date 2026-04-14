module top_module(
   input              RENDERER_CLK   ,


   input  wire [10:0] RENDERER_POS_X ,
   input  wire  [9:0] RENDERER_POS_Y ,
   input  wire        RENDERER_ENABLE,
	input  wire        RENDERER_SEL_BUFF,
	



   input  wire [ 7:0] RENDERER_DATA ,
   output wire [18:0] RENDERER_ADDR ,
   output wire        RENDERER_WE   ,
   output wire        RENDERER_OE   ,
   output wire        RENDERER_CE   ,



   output wire [ 4:0] RENDERER_RED   ,
   output wire [ 4:0] RENDERER_GREEN ,
   output wire [ 4:0] RENDERER_BLUE 


);localparam RENDERER_COLOR_FORMAT_332 = 2'b00;
localparam RENDERER_COLOR_FORMAT_555 = 2'b01;

localparam RENDERER_RESOLUTION_H = 10'd400;
localparam RENDERER_RESOLUTION_V = 10'd300;
localparam RENDERER_PIXEL_WITH   = 10'd2;

assign RENDERER_ADDR = RENDERER_RESOLUTION_H * ( RENDERER_POS_Y / RENDERER_PIXEL_WITH ) 
         + ( RENDERER_POS_X / RENDERER_PIXEL_WITH ) + RENDERER_RESOLUTION_H * RENDERER_RESOLUTION_V * SelectBuffer;

reg SelectBuffer = 0;

always @( posedge RENDERER_CLK )
begin
 	if( RENDERER_POS_Y == 0 && RENDERER_POS_X == 0 )
      SelectBuffer <= RENDERER_SEL_BUFF;
end


function [4:0] GetColorRed( input [2:0] colorFormat, input [7:0] value );
begin
    GetColorRed = value[ 2:0 ] << 2;
end
endfunction


function [4:0] GetColorGreen( input [2:0] colorFormat, input [7:0] value );
begin
    GetColorGreen = value[ 5:3 ] << 2;
end
endfunction

function [4:0] GetColorBlue( input [2:0] colorFormat, input [7:0] value );
begin
    GetColorBlue = value[ 7:6 ] << 2;
end
endfunction

assign RENDERER_RED   = ( RENDERER_ENABLE ) ? GetColorRed  ( RENDERER_COLOR_FORMAT_332, RENDERER_DATA ) : 5'b00000;
assign RENDERER_GREEN = ( RENDERER_ENABLE ) ? GetColorGreen( RENDERER_COLOR_FORMAT_332, RENDERER_DATA ) : 5'b00000;
assign RENDERER_BLUE  = ( RENDERER_ENABLE ) ? GetColorBlue ( RENDERER_COLOR_FORMAT_332, RENDERER_DATA ) : 5'b00000;

assign RENDERER_CE    = 1'b0;
assign RENDERER_WE    = 1'b1;
assign RENDERER_OE    = 1'b0;

endmodule