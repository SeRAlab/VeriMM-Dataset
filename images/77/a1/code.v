module top_module(
	input clk,
	input reset,
	input up_down,
	output reg [2:0] q);always @(posedge clk)
		if (reset)
			q <= 3'b010;
		else if (up_down)
			q <= q + 1;
		else
			q <= q - 1;

endmodule