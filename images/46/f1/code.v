module top_module(
	input clk,
	input reset,
	input [7:0] d,
	output reg [7:0] q);always @(posedge clk or posedge reset)
	if (reset)
		q <= 8'b00000000;
	else
		q <= d;

endmodule