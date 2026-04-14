module top_module(
	input clk,
	input reset_n,
	output reg [3:0] q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 0;
	else
		q <= q + 1;

endmodule