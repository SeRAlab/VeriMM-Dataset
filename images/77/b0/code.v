module lfsr(
	input clk,
	input load,
	input [15:0] seed,
	output [15:0] lfsr_out);reg [15:0] lfsr_reg;

	always @(posedge clk)
		if (load) lfsr_reg <= seed;
		else lfsr_reg <= {lfsr_reg[14:0], lfsr_reg[15] ^ lfsr_reg[13]};

	assign lfsr_out = lfsr_reg;

endmodule