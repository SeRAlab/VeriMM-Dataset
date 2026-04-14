module johnson_counter(
	input clk,
	input reset,
	output [5:0] count);reg [5:0] count_reg;

	always @(posedge clk)
		if (reset) count_reg <= 6'b000000;
		else count_reg <= {count_reg[4:0], ~count_reg[5]};

	assign count = count_reg;

endmodule