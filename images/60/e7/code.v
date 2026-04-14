module top_module(
	input clk,
	input enable,
	output [3:0] count);logic [3:0] count_value;

	always @(posedge clk)
		if (enable) count_value <= count_value + 1;

	assign count = count_value;

endmodule