module top_module (
	input clk,
	input rst,
	input a,
	output reg q);always @(posedge clk)
	if (rst)
		q <= 0;
	else
		q <= a;
		
endmodule