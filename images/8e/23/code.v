module top_module(
	input clk,
	input reset,
	input [1:0] d,
	output reg [1:0] q);always @(posedge clk)
		if (reset)
			q <= 2'b00;
		else
			q <= {q[0], d[1]};

endmodule