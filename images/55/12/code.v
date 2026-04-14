module up_down_counter(
	input clk,
	input reset,
	input up,
	input down,
	output [2:0] count);reg [2:0] count_reg;

	always @(posedge clk or posedge reset)
		if (reset) count_reg <= 3'b111;
		else if (up && !down) count_reg <= count_reg + 1;
		else if (!up && down) count_reg <= count_reg - 1;

	assign count = count_reg;

endmodule