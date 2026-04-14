module top_module(RegData, ReadData, FPReadData, floatop);input [63:0] ReadData, FPReadData;
	input floatop;
	

	output reg [63:0] RegData;
	
	always @(*)
		begin
			if(floatop == 0)
				RegData <= ReadData;
			else 
				RegData <= FPReadData;
		end
		
endmodule