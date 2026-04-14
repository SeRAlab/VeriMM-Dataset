module fibonacci_lfsr (
	input clk,
	output [5:0] q);reg [5:0] lfsr_reg = 6'b000001;

	always @(posedge clk) begin
		lfsr_reg <= {lfsr_reg[4:0], lfsr_reg[5] ^ lfsr_reg[4]};
	end
	
	assign q = lfsr_reg;
	
endmodule