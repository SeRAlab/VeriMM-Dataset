module top_module(
	input clk,
	input reset,
	input enable,
	output reg q);always @(posedge clk)
		if (reset)
			q <= 0;
		else if (enable)
			q <= ~q;

endmodule