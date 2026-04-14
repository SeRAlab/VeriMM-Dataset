module top_module(
input wire clk,
input wire reset,
output reg vga_h_sync,
output reg vga_v_sync,
output reg [10:0] CounterX,
output reg [10:0] CounterY,
output reg inDisplayArea
    );parameter TotalHorizontalPixels = 11'd800;
parameter HorizontalSyncWidth = 11'd96;
parameter VerticalSyncWidth = 11'd2;

parameter TotalVerticalLines = 11'd525;
parameter HorizontalBackPorchTime = 11'd144 ;
parameter HorizontalFrontPorchTime = 11'd784 ;
parameter VerticalBackPorchTime = 11'd12 ;
parameter VerticalFrontPorchTime = 11'd492;

reg VerticalSyncEnable;

reg [10:0] HorizontalCounter;
reg [10:0] VerticalCounter;


always @(posedge clk or posedge reset)
begin
	if(reset == 1)
		HorizontalCounter <= 0;
	else
		begin
			if(HorizontalCounter == TotalHorizontalPixels - 1)
				begin 
					HorizontalCounter<=0;
					VerticalSyncEnable <= 1;
				end
			else
				begin 
					HorizontalCounter<=HorizontalCounter+1; 
					VerticalSyncEnable <=0;
				end
		end
end




always @(*)
begin
	if((HorizontalCounter<HorizontalSyncWidth))
		vga_h_sync = 1;
	else
		vga_h_sync = 0;
end



always @(posedge clk or posedge reset)
begin
	if(reset == 1)
		VerticalCounter<=0;
	else
	begin
		if(VerticalSyncEnable == 1)
			begin
				if(VerticalCounter==TotalVerticalLines-1)
					VerticalCounter<=0;
				else
					VerticalCounter<=VerticalCounter+1;
			end
	end
end


always @(*)
begin
	if(VerticalCounter < VerticalSyncWidth)
		vga_v_sync = 1;
	else
		vga_v_sync = 0;
end

always @(posedge clk)
begin
	if((HorizontalCounter<HorizontalFrontPorchTime) && (HorizontalCounter>HorizontalBackPorchTime) && (VerticalCounter<VerticalFrontPorchTime) && (VerticalCounter>VerticalBackPorchTime))
		begin
			inDisplayArea <= 1;
			CounterX<= HorizontalCounter - HorizontalBackPorchTime;
			CounterY<= VerticalCounter - VerticalBackPorchTime;
		end
	else
		begin
			inDisplayArea <= 0;
			CounterX<=0;
			CounterY<=0;
		end
end

endmodule