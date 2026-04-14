module top_module(
	input clk,
	input reset,
	input enable,
	output reg [1:0] q);always @(posedge clk)
	if (reset)
		q <= 0;
	else if (enable)
		q <= q + 1;

endmodule