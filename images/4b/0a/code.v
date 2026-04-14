module top_module(
	input clk,
	input reset,
	output [3:0] count);logic [3:0] count_reg;

	always @(posedge clk or posedge reset)
		if (reset) count_reg = 0;
		else count_reg = count_reg + 1;

	assign count = count_reg;

endmodule