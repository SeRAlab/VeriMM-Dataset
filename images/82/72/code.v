module top_module(
	input clk,
	input reset,
	output reg [3:0] q);always @(posedge clk)
		if (!reset)
			q <= 15;
		else if (q == 0)
			q <= 15;
		else
			q <= q - 1;

endmodule