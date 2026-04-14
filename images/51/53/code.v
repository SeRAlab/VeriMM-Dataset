module top_module(clk, rst, push, switch, pixel_x, pixel_y, video_on, rgb);input clk, rst;
input [3:0] push;
input [2:0] switch;
input [9:0] pixel_x, pixel_y;
input video_on;
output reg [2:0] rgb;

wire square_on, refr_tick;


localparam MAX_X = 640;
localparam MAX_Y = 480;

localparam SQUARE_SIZE = 40;
localparam SQUARE_VEL = 5;


wire [9:0] square_x_left, square_x_right, square_y_top, square_y_bottom;
reg [9:0] square_y_reg, square_y_next;
reg [9:0] square_x_reg, square_x_next;


always @(posedge clk) begin
	if(rst) begin
		square_y_reg <= 240;
		square_x_reg <= 320;
	end
	else begin
		square_y_reg <= square_y_next;
		square_x_reg <= square_x_next;
	end
end

assign refr_tick = (pixel_y ==481) && (pixel_x ==0);


assign square_y_top = square_y_reg;
assign square_x_left = square_x_reg;
assign square_y_bottom = square_y_top + SQUARE_SIZE - 1;
assign square_x_right = square_x_left + SQUARE_SIZE - 1;


always @(*) begin
	rgb = 3'b000;
	if(video_on) begin
		if(square_on)
			rgb = switch;
		else
			rgb = 3'b110;
	end
end

assign square_on = ((pixel_x > square_x_left) && (pixel_x < square_x_right)) && ((pixel_y > square_y_top) && (pixel_y < square_y_bottom));


always @(*) begin
	square_y_next = square_y_reg;
	square_x_next = square_x_reg;
	if(refr_tick) begin
		if (push[0] && (square_x_right < MAX_X - 1)) begin 
			square_x_next = square_x_reg + SQUARE_VEL; 
		end 
		else if (push[1] && (square_x_left > 1 )) begin
			square_x_next = square_x_reg - SQUARE_VEL; 
		end
		else if (push[2] && (square_y_bottom < MAX_Y - 1 )) begin
			square_y_next = square_y_reg + SQUARE_VEL; 
		end
		else if (push[3] && (square_y_top > 1)) begin
			square_y_next = square_y_reg - SQUARE_VEL; 
		end
	end
end

endmodule