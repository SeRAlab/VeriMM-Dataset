module top_module(
	input clk,
	input reset,
	input [3:0] in,
	output reg q);always @(posedge clk)
		if (reset)
			q <= 0;
		else
			q <= (in == 4'b1010);

endmodule