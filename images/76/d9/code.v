module top_module(
	input clk,
	input enable,
	input reset,
	output [1:0] count);logic [1:0] count_value;

	always @(posedge clk)
		if (reset) count_value <= 2'b00;
		else if (enable) count_value <= count_value + 1;

	assign count = count_value;

endmodule