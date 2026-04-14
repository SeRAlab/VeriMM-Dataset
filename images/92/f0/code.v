module top_module(
	input clk,
	input reset,
	input toggle,
	output reg [2:0] q);always @(posedge clk)
		if (reset)
			q <= 0;
		else
			q <= q + (toggle ? 2 : 1);
	
endmodule