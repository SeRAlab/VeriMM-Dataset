module top_module (
	input clk,
	input rst,
	output reg q);always @(posedge clk)
	if (rst)
		q <= 0;
	else
		q <= ~q;

endmodule