module hvsync_gen(
			clk,
			h_sync,
			v_sync,
			wcntX,
			wcntY
		 );
input clk;
output h_sync;
output v_sync;
output [9:0] wcntX;
output [8:0] wcntY;
parameter PIXEL_CLOCK = 25;
parameter GLOBAL_CLOCK = 50;
parameter MULT_FACTOR = GLOBAL_CLOCK / PIXEL_CLOCK;
parameter VGA_H_SYNC_PULSE  = 96 * MULT_FACTOR;
parameter VGA_H_FRONT_PORCH = 16 * MULT_FACTOR;
parameter VGA_H_BACK_PORCH  = 48 * MULT_FACTOR;
parameter VGA_H_PIXEL_COUNT = 800 * MULT_FACTOR;
parameter VGA_V_SYNC_PULSE  = 2;
parameter VGA_V_FRONT_PORCH = 10;
parameter VGA_V_BACK_PORCH  = 33;
parameter VGA_V_LINE_COUNT  = 525;
reg vga_HS;
reg vga_VS;
reg [10:0] cntX;
reg [9:0]  cntY;
reg [9:0] wcntX;
reg [8:0] wcntY;
wire cntXmaxed = (cntX == VGA_H_PIXEL_COUNT - 1);
wire cntYmaxed = (cntY == VGA_V_LINE_COUNT - 1);
always @(posedge clk) begin
	if(cntYmaxed) begin
			 cntY <= 0;
			wcntY <= 0;
	end
	if(cntXmaxed) begin
	     cntX <= 0;
		  cntY <= cntY + 1;
		 wcntX <= 0;		  
	 	 if (   (cntY > VGA_V_SYNC_PULSE + VGA_V_FRONT_PORCH) 
		 	  && (cntY < VGA_V_LINE_COUNT - VGA_V_BACK_PORCH)
				)
		 begin
		     wcntY <= wcntY + 1;
		 end
	end
	else begin
		 if (   (cntX[10:0] > VGA_H_SYNC_PULSE + VGA_H_FRONT_PORCH) 
			  && (cntX[10:0] < VGA_H_PIXEL_COUNT  - VGA_H_BACK_PORCH) 
			  && (cntX[0] == 0)  
			 ) 
		  begin
				wcntX <= wcntX + 1;
		  end
		  cntX <= cntX + 1;
	end
end
always @(posedge clk)
begin
	vga_HS <= (cntX[10:0] < VGA_H_SYNC_PULSE);
	vga_VS <= (cntY[9:0] < VGA_V_SYNC_PULSE);
end
assign h_sync = ~vga_HS;
assign v_sync = ~vga_VS;
endmodule