module top_module(
	input clk,
	output [3:0] out);logic [3:0] johnson_reg;

	always @(posedge clk)
		johnson_reg <= {~johnson_reg[0], johnson_reg[3:1]};

	assign out = johnson_reg;

endmodule