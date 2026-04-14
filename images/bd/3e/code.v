module top_module(
	input clk,
	input reset,
	input sel,
	input [7:0] a,
	input [7:0] b,
	output reg [7:0] q);always @(posedge clk)
		if (reset)
			q <= 8'b00000000;
		else
			q <= sel ? b : a;

endmodule