module top_module(
	input clk,
	input reset,
	input d,
	output q);logic q_reg;

	always @(posedge clk or posedge reset)
		if (reset) q_reg <= 0;
		else q_reg <= d;

	assign q = q_reg;

endmodule