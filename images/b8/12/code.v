module top_module(
	input clk,
	input reset,
	output reg [23:0] q);always @(posedge clk)
	if (reset)
		q <= 24'b0;
	else
		q <= q - 2;

endmodule