module top_module(
	input clk,
	input reset_n,
	input [3:0] data_in,
	output reg [3:0] q);always @(posedge clk)
	if (!reset_n)
		q <= 0;
	else
		q <= {q[2:0], data_in[0]};

endmodule