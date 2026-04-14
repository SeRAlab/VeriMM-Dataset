module top_module (
	input clk,
	input i, 
	output reg [2:0] y);always @(posedge clk)
		if (i)
			y <= 1;
		else if (y == 3)
			y <= 0;
		else
			y <= y + 1'b1;
			
endmodule