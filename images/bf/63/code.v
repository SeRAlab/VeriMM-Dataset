module top_module(
	input clk,
	input reset,
	output reg [9:0] count);always @(posedge clk)
	if (reset)
		count <= 10'b1111111111;
	else
		count <= count + 1;

endmodule