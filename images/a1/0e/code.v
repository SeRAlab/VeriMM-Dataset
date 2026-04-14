module top_module(
	input clk,
	input reset_n,
	input en,
	output reg [5:0] q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 6'b0;
	else if (en)
		q <= q + 1;

endmodule