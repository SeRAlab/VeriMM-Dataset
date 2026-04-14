module top_module(
	input clk,
	input reset,
	input [9:0] data,
	output reg [9:0] q);always @(posedge clk or posedge reset)
	if (reset)
		q <= 0;
	else
		q <= {data[9], q[9:1]};

endmodule