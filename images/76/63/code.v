module top_module(
	input clk,
	input reset,
	input t,
	output reg q);always @(posedge clk or negedge reset)
	if (!reset)
		q <= 1;
	else if (t)
		q <= ~q;

endmodule