module top_module(
	input clk,
	output [5:0] count);logic [5:0] count_value;

	always @(posedge clk)
		if (count_value == 6'd63) count_value <= 6'd0;
		else count_value <= count_value + 1;

	assign count = count_value;

endmodule