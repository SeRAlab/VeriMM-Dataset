module top_module (
	input clk,
	input k,
	input l,
	output reg j,
	output reg state);always @(posedge clk)
	state <= k & ~l;
	
assign j = state;
	
endmodule