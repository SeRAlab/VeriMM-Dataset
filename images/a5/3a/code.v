module top_module(
	input clk,
	input reset,
	output reg [3:0] q);always @(posedge clk)
		if (reset)
			q <= 4'b0011;
		else
			q <= {1'b0, q[3:1]};

endmodule