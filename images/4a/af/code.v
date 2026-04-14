module top_module(
	input clk,
	input reset,
	output reg q);always @(posedge clk)
		if (reset)
			q <= 0;
		else
			q <= ~q;

endmodule