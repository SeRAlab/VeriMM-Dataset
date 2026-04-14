module lfsr_8bit (
	input clk,
	output [7:0] q);reg [7:0] lfsr_reg = 8'b00000001;

	always @(posedge clk) begin
		lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[5]};
	end
	
	assign q = lfsr_reg;
	
endmodule