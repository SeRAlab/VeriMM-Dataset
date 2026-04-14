module top_module (
	input clk,
	input p,
	input q,
	output reg r,
	output reg state);always @(posedge clk)
	state <= p & ~q;
	
assign r = state;
	
endmodule