module top_module(
	input clk,
	input reset,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk)
	if (reset)
		q <= 0;
	else
		q <= data;

endmodule