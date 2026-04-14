module top_module (
	input clk,
	input h, 
	output reg [2:0] x);always @(posedge clk)
		if (h)
			x <= 3;
		else if (x == 6)
			x <= 0;
		else
			x <= x + 1'b1;
			
endmodule