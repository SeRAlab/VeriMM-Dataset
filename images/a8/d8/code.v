module top_module(input clock, reset, output downClock);reg [25:0] cycleCount;
				
				always @(posedge clock) 
				begin
				
					if (reset == 1'b0) 
						cycleCount <= 26'd0;						
					else if (cycleCount == 26'd0) 
						cycleCount <= 26'd25000000; 
					else
						cycleCount <= cycleCount - 1'b1; 
						
				end
				
				assign downClock = (cycleCount == 26'd0) ? (1'b1):(1'b0);endmodule