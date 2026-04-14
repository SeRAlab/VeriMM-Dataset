module top_module(
	input clk,
	output [2:0] q);logic [2:0] q_reg;

	always @(posedge clk)
		q_reg <= {q_reg[0], q_reg[2:1]};

	assign q = q_reg;

endmodule