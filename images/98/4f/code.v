module top_module(
	input clk,
	input reset,
	input dir,
	output reg [3:0] q);always @(posedge clk)
		if (reset)
			q <= 0;
		else if (dir)
			q <= q + 1;
		else
			q <= q - 1;
	
endmodule