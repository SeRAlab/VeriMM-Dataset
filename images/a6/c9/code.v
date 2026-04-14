module top_module(
	input clk,
	input reset,
	input load,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk)
	if (reset)
		q <= 16'b0000000000000000;
	else if (load)
		q <= data;

endmodule