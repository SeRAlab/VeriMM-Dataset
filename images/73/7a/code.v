module top_module(
	input clk,
	input reset,
	output reg [2:0] q);always @(posedge clk)
	if (reset)
		q <= 3'b100;
	else
		q <= {q[1:0], ~q[2]};

endmodule