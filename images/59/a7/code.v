module top_module(
	input clk,
	input T,
	output q);logic q_reg;

	always @(posedge clk)
		if (T) q_reg = ~q_reg;

	assign q = q_reg;

endmodule