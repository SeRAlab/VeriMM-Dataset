module top_module(
	input clk,
	input enable,
	input in,
	output [2:0] q);logic [2:0] q_reg;

	always @(posedge clk)
		if (enable) q_reg <= {in, q_reg[2:1]};

	assign q = q_reg;

endmodule