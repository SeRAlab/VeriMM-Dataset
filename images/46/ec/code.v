module top_module(
	input clk,
	input reset,
	input enable,
	input [15:0] d,
	output reg [15:0] q);always @(posedge clk)
	if (reset)
		q <= 16'b0;
	else if (enable)
		q <= d;

endmodule