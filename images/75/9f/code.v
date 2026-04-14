module top_module(input clk, output reg clk1 = 0);parameter divide = 16;
	integer cnt = 0;
	always @(posedge clk) begin
		cnt <= (cnt?cnt:(divide/2)) - 1;
		if (!cnt) clk1 <= ~clk1;
	end
	
endmodule