module top_module(
	input clk,
	input reset,
	input up,
	output reg [3:0] q);always @(posedge clk)
		if (reset)
			q <= 0;
		else if (up)
			q <= (q == 15) ? 15 : q + 1;
		else
			q <= (q == 0) ? 0 : q - 1;
	
endmodule