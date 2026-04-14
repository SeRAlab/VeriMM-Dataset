module top_module(
	input clk,
	input reset,
	input d,
	output reg q);always @(posedge clk or negedge reset)
	if (!reset)
		q <= 1;
	else
		q <= d;

endmodule