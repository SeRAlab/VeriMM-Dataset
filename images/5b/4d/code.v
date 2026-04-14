module top_module(
input wire video_on,
input wire [9:0] pixel_x, pixel_y,
output wire graph_on,
output reg [7:0] fig_RGB 
);localparam MAX_X = 640;
localparam MAX_Y = 480;


localparam BOX_H_XL = 160; 
localparam BOX_H_XR = 479; 
localparam BOX_H_YT = 64;
localparam BOX_H_YB = 255;


localparam BOX_F_XL = 48;
localparam BOX_F_XR = 303;
localparam BOX_F_YT = 352;
localparam BOX_F_YB = 447;


localparam BOX_T_XL = 336;
localparam BOX_T_XR = 591;
localparam BOX_T_YT = 352;
localparam BOX_T_YB = 447;


wire BOX_H_on, BOX_F_on, BOX_T_on;
wire [7:0] BOX_H_RGB, BOX_F_RGB, BOX_T_RGB;




assign BOX_H_on = (BOX_H_XL<=pixel_x)&&(pixel_x<=BOX_H_XR)
						&&(BOX_H_YT<=pixel_y)&&(pixel_y<=BOX_H_YB);

assign BOX_H_RGB = 8'h1E;


assign BOX_F_on = (BOX_F_XL<=pixel_x)&&(pixel_x<=BOX_F_XR)
						&&(BOX_F_YT<=pixel_y)&&(pixel_y<=BOX_F_YB);

assign BOX_F_RGB = 8'h1E;


assign BOX_T_on = (BOX_T_XL<=pixel_x)&&(pixel_x<=BOX_T_XR)
						&&(BOX_T_YT<=pixel_y)&&(pixel_y<=BOX_T_YB);

assign BOX_T_RGB = 8'h1E;


always @*
begin	
	if(~video_on)
		fig_RGB = 8'b0;
	
	else
		if (BOX_H_on) fig_RGB = BOX_H_RGB;
		else if (BOX_F_on) fig_RGB = BOX_F_RGB;
		else if (BOX_T_on) fig_RGB = BOX_T_RGB;
		else fig_RGB = 8'b0;
end

assign graph_on = BOX_H_on | BOX_F_on | BOX_T_on;
	
endmodule