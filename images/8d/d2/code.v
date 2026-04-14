module top_module(
	input clk,
	input reset,
	input [3:0] data,
	output reg [3:0] q);always @(posedge clk)
	if (reset)
		q <= 4'b0000;
	else
		q <= {q[2:0], data[3]};

endmodule