module top_module(
	input clk,
	input reset,
	output reg [1:0] q);always @(posedge clk)
		if (reset)
			q <= 2'b00;
		else
			q <= q + 1;

endmodule