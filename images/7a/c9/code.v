module top_module(
	input clk,
	input reset,
	input j,
	input k,
	output reg q);always @(posedge clk)
	if (reset)
		q <= 0;
	else if (j & ~k)
		q <= 1;
	else if (~j & k)
		q <= 0;
	else if (j & k)
		q <= ~q;

endmodule