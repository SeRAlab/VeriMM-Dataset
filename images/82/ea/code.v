module top_module (
	input clk,
	input rst, 
	output reg out);always @(posedge clk)
	if (rst)
		out <= 1'b0;
	else
		out <= ~out;

endmodule