module top_module(
	input clk,
	input reset,
	input [2:0] data,
	output reg [2:0] q);always @(posedge clk)
	if (reset)
		q <= 0;
	else
		q <= {q[1:0], data[2]};

endmodule