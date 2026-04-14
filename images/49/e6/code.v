module top_module(
	input wire hsync,
	input wire pixel_clk_2x, 
	input wire [23:0] pixel_data,
	output reg [11:0] vga_out
    );reg pixel_ab; 
	 reg hsync_last = 0;
	 reg [23:0] stored_pixel;
	 reg [11:0] pixel_b;
	 
	 
	 always@(posedge pixel_clk_2x)
	 begin
		 hsync_last <= hsync;
		 
		pixel_ab <= ((hsync_last==0)&&(hsync==1)) ? 1 : ~pixel_ab;
		
		
		pixel_b <= pixel_data[11:0];
		vga_out <= pixel_ab ? pixel_b : pixel_data[23:12];  
	 end


endmodule