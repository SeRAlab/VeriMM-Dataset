module top_module(
    input  wire clk,
	 input  wire [2:0] redin,
	 input  wire [2:0] greenin,
	 input  wire [1:0] bluein,
	 output reg [9:0] hc,
    output reg [9:0] vc,
	 output wire hsync,
	 output wire vsync,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [1:0] blue
    );parameter hpixels = 800;
parameter vlines = 521; 
parameter hpulse = 96; 	
parameter vpulse = 2; 	
parameter hbp = 144; 	
parameter hfp = 784; 	
parameter vbp = 31; 		
parameter vfp = 511; 	




always @(posedge clk)
begin
	if (hc < hpixels - 1)					
		hc <= (hc + 1'b1);
	else											
	begin
		hc <= 0;
		if (vc < vlines - 1)
			vc <= (vc + 1'b1);
		else
			vc <= 0;
	end
end


assign hsync = (hc < hpulse) ? 1'b0:1'b1;
assign vsync = (vc < vpulse) ? 1'b0:1'b1;


always @(*)
begin
	if (vc >= vbp && vc < vfp)					
	begin
		if (hc >= hbp && hc < (hbp+640))		
		begin
			red = redin;
			green = greenin;
			blue = bluein;
		end
		else											
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	else												
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule