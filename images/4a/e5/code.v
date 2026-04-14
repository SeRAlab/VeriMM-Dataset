module top_module(
	clk25mhz,
	hindex,
	vindex,
	hsync,
	vsync
);input wire clk25mhz;



output reg[9:0] hindex = 0;
output reg[9:0] vindex = 0;
output reg hsync;
output reg vsync;



always @ (posedge clk25mhz) begin: indexes
	if(hindex == 799) begin
		hindex <= 0;
		
		if(vindex == 524) begin
			vindex <= 0;
		end else begin
			vindex <= vindex + 1;
		end
	end else begin
		hindex <= hindex + 1;
	end
end

always @ (posedge clk25mhz) begin: vsync_output
	if(vindex >= 490 && vindex <= 491) begin
		vsync <= 0;
	end else begin
		vsync <= 1;
	end
end

always @ (posedge clk25mhz) begin: hsync_output
	
	if(hindex >= 657 && hindex <= 752) begin
		hsync <= 0;
	end else begin
		hsync <= 1;
	end
end

endmodule