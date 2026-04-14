module top_module (
	input clk,
	input rst,
	input d,
	input en,
	output reg q);always @(posedge clk)
	if (rst)
		q <= 0;
	else if (en)
		q <= d;
		
endmodule