module top_module(clk,rst,button,throw);input clk, rst, button;
	output reg [2:0] throw;

	always @(posedge clk) 
	begin
	if (rst || throw == 3'b111)
		throw <= 3'b001;
	else if (button && throw != 3'b110)
		throw <= throw + 1;
	else if (button && throw == 3'b110)
		throw <= 3'b001;
	end

endmodule