module top_module(
	input clk,
	input reset_n,
	input enable_n,
	output reg [3:0] q);always @(posedge clk)
	if (!reset_n)
		q <= 0;
	else if (!enable_n)
		q <= q + 1;

endmodule