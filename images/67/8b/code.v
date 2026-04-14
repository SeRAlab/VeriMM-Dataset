module top_module (
	input clk,
	input x,
	output reg y,
	output reg state);always @(posedge clk)
	state <= x;

assign y = state;
	
endmodule