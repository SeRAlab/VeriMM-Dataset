module top_module(
	input clk,
	input reset,
	output reg [5:0] q);always @(posedge clk)
	if (reset) q <= 6'b0;

endmodule