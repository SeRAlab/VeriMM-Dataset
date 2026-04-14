module top_module(
	input clk,
	input load,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk)
		if (load)
			q <= data;
	
endmodule