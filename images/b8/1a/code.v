module clock_gater(
	input clk_in,
	input enable,
	output clk_gated
);

	assign clk_gated = clk_in & enable;

endmodule