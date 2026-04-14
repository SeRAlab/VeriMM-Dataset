module top_module(hc, vc, mem_value, rom_addr, R, G, B, blank, inside_image);input [10:0] hc, vc;	
	input [7:0] mem_value;	
	input blank;
	output reg [14:0] rom_addr;	
	output reg [2:0] R, G;
	output reg [1:0] B;	
	output reg inside_image;
	
	parameter [10:0] VGA_WIDTH = 640;
	parameter [10:0] VGA_HEIGHT = 480;
	
	parameter [7:0] IMG_WIDTH = 175;
	parameter [7:0] IMG_HEIGHT = 175;
	
	parameter [3:0] SCALE = 1;
	
	parameter [10:0] START_X = (VGA_WIDTH - (IMG_WIDTH * SCALE)) / 2;
	parameter [10:0] START_Y = (VGA_HEIGHT - (IMG_HEIGHT * SCALE)) / 2;
	parameter [10:0] END_X = START_X + IMG_WIDTH;
	parameter [10:0] END_Y = START_Y + IMG_HEIGHT;
	
	reg [10:0] x, y;
	
	wire [10:0] div_hc, div_vc;
	wire [11:0] mult_x1, mult_y1;
	
	assign div_hc = hc >> (SCALE >> 1);
	assign div_vc = vc >> (SCALE >> 1);
	assign mult_x1 = END_X << (SCALE >> 1);
	assign mult_y1 = END_Y << (SCALE >> 1);
	
	always @ (*) begin
	
		if (hc >= START_X & hc <= mult_x1)		
			x = div_hc - START_X;	
		else
			x = 0;
			
		if (vc >= START_Y & vc <= mult_y1)		
			y = div_vc - START_Y;	
		else
			y = 0;
			
		rom_addr = y*IMG_WIDTH + x;
		
		if (x==0 | y==0) begin		
			{R,G,B} = 8'd0;
			inside_image <= 1'b0;
		end else begin
			{R,G,B} = mem_value;
			inside_image <= 1'b1;
		end
			
	end
endmodule