module top_module(
	input clk,
	input reset_n,
	input en,
	input [1:0] data,
	output reg [1:0] q);always @(posedge clk)
	if (!reset_n)
		q <= 0;
	else if (en)
		q <= data;

endmodule