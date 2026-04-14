module top_module (
	input clk,
	input reset,
	input d,
	output reg q);always @(posedge clk)
	if (reset)
		q <= 0;
	else
		q <= d;
		
endmodule