module top_module (
	input clk,
	input reset,
	output reg control);

always @(posedge clk)
	if (reset)
		control <= 1'b1;
	else
		control <= ~control;

endmodule