module top_module (
	input clk,
	input x,
	input y,
	output reg z,
	output reg state);always @(posedge clk)
	state <= x & ~y;
	
assign z = state;
	
endmodule