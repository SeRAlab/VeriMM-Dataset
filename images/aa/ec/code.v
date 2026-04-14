module top_module(
	input clk,
	input reset,
	input a,
	input b,
	output reg q);always @(posedge clk)
		if (reset)
			q <= 0;
		else
			q <= a & b;

endmodule