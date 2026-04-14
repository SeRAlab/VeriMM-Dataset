module top_module(
	input clk,
	input reset,
	output [7:0] lfsr);reg [7:0] lfsr_reg;

always @(posedge clk or posedge reset)
	if (reset)
		lfsr_reg <= 8'b00000001;
	else
		lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[5]};

assign lfsr = lfsr_reg;

endmodule