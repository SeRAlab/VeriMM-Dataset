module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] q);always @(posedge clk)
	if (reset)
		q <= 0;
	else
		q <= q + in;

endmodule