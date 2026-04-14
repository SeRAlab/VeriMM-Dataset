module top_module(
	input clk,
	input reset,
	input load,
	input [3:0] data,
	output reg [3:0] q);always @(posedge clk)
		if (reset)
			q <= 0;
		else if (load)
			q <= data;
	
endmodule