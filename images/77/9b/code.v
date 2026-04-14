module top_module(compIn, compOut);input [7:0] compIn;
	output reg [7:0] compOut;
	
	always@(compIn,compOut)
		begin
			compOut = ~compIn + 8'd1;
		end
		
endmodule