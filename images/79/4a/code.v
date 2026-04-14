module top_module(
	clk,
	reset,
	pixel_x, 
	pixel_y,
	din,
	px_rgb,
	addr_r
   );input	clk;	
	input	reset;	
	input	[9:0] pixel_x; 
	input	[9:0] pixel_y;
	input   [31:0] din;
	

	output  [7:0] px_rgb;
	output  [18:0] addr_r;
	

	wire 	clk;
	wire 	reset;
	wire	[9:0] pixel_x; 
	wire	[9:0] pixel_y;
	wire    [31:0] din;
	

	reg     [7:0] px_rgb;
	wire    [18:0] addr_r;
	

	
	


  
   	
	assign addr_r = {9'b0, pixel_x[9:3] + pixel_y};


	always @*
	begin	
		case (pixel_x[1:0])
			2'b00: px_rgb  <= din[7:0];
			2'b01: px_rgb  <= din[15:8];	
			2'b01: px_rgb  <= din[23:16];
			2'b01: px_rgb  <= din[31:24];	
			default:  px_rgb  <= 8'd0;
		endcase
		
	end
	
endmodule