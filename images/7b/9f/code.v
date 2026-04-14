module top_module(
	input clk,
	input reset,
	output reg [15:0] q);always @(posedge clk)
	if (reset)
		q <= 16'hFFFF;
	else
		q <= {1'b0, q[15:1]};

endmodule