module top_module (
	input clk,
	input d,
	output reg q,
	output reg state);always @(posedge clk)
	state <= d;

assign q = state;
	
endmodule