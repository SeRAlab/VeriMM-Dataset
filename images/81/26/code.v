module top_module(
	input clk,
	input reset,
	input [3:0] a,
	input [3:0] b,
	output reg [3:0] q);always @(posedge clk)
		if (reset)
			q <= 4'b0000;
		else
			q <= a & b;

endmodule