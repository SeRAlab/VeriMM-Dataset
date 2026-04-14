module top_module(input clk25, input reset, output reg vSync, output reg hSync, output [7:0] xCoord, output [8:0] yCoord, output draw);parameter [9:0] HmaxCount = 799;
	parameter [9:0] VmaxCount = 520;
	
	reg [9:0] hCount, vCount;
	
	wire hHitMax = (hCount == HmaxCount);
	wire vHitMax = (vCount == VmaxCount);
	
	assign draw = (hCount < 256) & (vCount < 320);
	
	assign xCoord = (draw) ? hCount[7:0] : 8'b00000000;
	assign yCoord = (draw) ? vCount[8:0] : 9'b000000000;
	
	always @(posedge clk25, posedge reset)
	if (reset)
		begin
			hCount <= 10'b0000000000;
			vCount <= 10'b0000000000;
			hSync <= 1'b1;
			vSync <= 1'b1;
		end
	else
		begin
			hCount <= (hHitMax) ? 10'b0000000000 : hCount + 1;
			vCount <= (vHitMax && hHitMax) ? 10'b0000000000 : (hHitMax) ? vCount + 1 : vCount;
			hSync <= (hCount == 655) ? 1'b0 : (hCount == 751) ? 1'b1 : hSync;
			vSync <= (vCount == 489 && hHitMax) ? 1'b0 : (vCount == 491 && hHitMax) ? 1'b1 : vSync;
		end


endmodule