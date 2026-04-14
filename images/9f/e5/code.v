module top_module(
	input clk,
	input reset,
	input enable,
	output reg [5:0] q);always @(posedge clk)
		if (reset)
			q <= 6'd63;
		else if (enable)
			q <= q - 1;
	
endmodule