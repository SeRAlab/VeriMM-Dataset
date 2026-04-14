module top_module (
	input clk,
	input reset,
	output reg signal);

always @(posedge clk)
	if (reset)
		signal <= 1'b1;
	else
		signal <= ~signal;

endmodule