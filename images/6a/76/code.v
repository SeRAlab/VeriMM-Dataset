module top_module(
	input clk,
	input reset,
	input load,
	input [15:0] d,
	output reg [15:0] q);always @(posedge clk)
	if (reset)
		q <= 0;
	else if (load)
		q <= d;

endmodule