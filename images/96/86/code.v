module top_module(
	input clk,
	input en,
	input [3:0] d,
	output reg [3:0] q);always @(posedge clk)
	if (en)
		q <= d;

endmodule