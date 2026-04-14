module top_module (
	input clk,
	input reset,
	output reg out);

always @(posedge clk)
	if (reset)
		out <= 1'b1;
	else
		out <= ~out;

endmodule