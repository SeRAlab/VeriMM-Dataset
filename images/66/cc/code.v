module top_module(
	input clk,
	input reset,
	input [15:0] data,
	output reg [15:0] q);always @(negedge clk or posedge reset)
	if (reset)
		q <= 0;
	else
		q <= data;

endmodule