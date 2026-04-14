module top_module (
	input clk,
	input e,
	input f,
	output reg g,
	output reg state);always @(posedge clk)
	state <= e & ~f;
	
assign g = state;
	
endmodule