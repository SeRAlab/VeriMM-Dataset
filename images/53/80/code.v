module top_module(
	input clk,
	output [3:0] out);logic [3:0] ring_reg;

	always @(posedge clk)
		ring_reg <= {ring_reg[2:0], ring_reg[3]};

	assign out = ring_reg;

endmodule