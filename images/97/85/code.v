module top_module(
	input clk,
	input reset,
	output reg [11:0] count);always @(posedge clk)
	if (reset)
		count <= 12'b0;
	else
		count <= count - 1;

endmodule