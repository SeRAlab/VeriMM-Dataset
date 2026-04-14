module top_module (
	input clk,
	input rst, 
	output reg q);always @(posedge clk or posedge rst)
	if (rst)
		q <= 0;
	else
		q <= 1;

endmodule