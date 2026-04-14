module top_module (
	input clk,
	input reset,
	output reg state);always @(posedge clk)
	if (reset)
		state <= 1'b0;
	else
		state <= ~state;

endmodule