module top_module(
	input clk,
	input reset,
	input enable,
	input load,
	input [9:0] d,
	output reg [9:0] q);always @(posedge clk)
	if (reset)
		q <= 10'b0;
	else if (load)
		q <= d;
	else if (enable)
		q <= q + 1;

endmodule