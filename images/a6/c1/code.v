module top_module (
	input clk,
	input w,
	output reg v,
	output reg state);always @(posedge clk)
	state <= w;

assign v = state;
	
endmodule