module top_module(
	input clk,
	input reset,
	input load,
	input [2:0] d,
	output reg [2:0] q);always @(posedge clk)
		if (reset)
			q <= 3'b000;
		else if (load)
			q <= d;
		else
			q <= q + 1;

endmodule