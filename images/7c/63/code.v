module top_module(
	input clk,
	input enable,
	output [1:0] count);logic [1:0] count_reg;

	always @(posedge clk)
		if (enable) count_reg = count_reg + 1;

	assign count = count_reg;

endmodule