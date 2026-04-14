module top_module(
	input clk,
	input reset,
	input en,
	output reg [2:0] q);always @(posedge clk or posedge reset)
	if (reset)
		q <= 3'b000;
	else if (en)
		q <= q + 1;

endmodule