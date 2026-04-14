module top_module(clk, rst, fifo_empty, blank, comp_sync, hsync, vsync);input clk;
	input rst;
	input fifo_empty;
	output blank;
	output comp_sync;
	output hsync;
	output vsync;
	
	reg [9:0] pixel_x;
	reg [9:0] pixel_y;
	
	
	wire [9:0] next_pixel_x;
	wire [9:0] next_pixel_y;
	assign next_pixel_x = (pixel_x == 10'd799)? 0 : pixel_x+1;
	assign next_pixel_y = (pixel_x == 10'd799)?
				((pixel_y == 10'd524) ? 0 : pixel_y+1)
					: pixel_y;
	
	always@(posedge clk)
	if(rst | fifo_empty) begin 
		pixel_x <= 10'h0;
		pixel_y <= 10'h0;
	end else begin
		pixel_x <= next_pixel_x;
		pixel_y <= next_pixel_y;
	end
	
	assign hsync = (pixel_x < 10'd656) || (pixel_x > 10'd751); 
	assign vsync = (pixel_y < 10'd490) || (pixel_y > 10'd491); 
	assign blank = ~((pixel_x > 10'd639) | (pixel_y > 10'd479));
	assign comp_sync = 1'b0; 
	 
endmodule