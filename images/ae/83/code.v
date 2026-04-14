module top_module (
	input clk,
	input a,
	output reg b,
	output reg state);always @(posedge clk)
	state <= a;

assign b = state;
	
endmodule