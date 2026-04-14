module top_module (
	input clk,
	input reset,
	output reg active);

always @(posedge clk)
	if (reset)
		active <= 1'b1;
	else
		active <= ~active;

endmodule