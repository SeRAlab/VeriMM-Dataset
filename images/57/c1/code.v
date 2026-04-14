module top_module(
	input clk,
	input reset,
	input direction,
	output reg [2:0] q);always @(posedge clk)
		if (reset)
			q <= 0;
		else if (direction)
			q <= q + 1;
		else
			q <= q - 1;

endmodule