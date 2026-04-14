module top_module(
	input clk,
	input up,
	output [3:0] count);logic [3:0] count_value;

	always @(posedge clk)
		if (up) count_value <= count_value + 1;
		else count_value <= count_value - 1;

	assign count = count_value;

endmodule