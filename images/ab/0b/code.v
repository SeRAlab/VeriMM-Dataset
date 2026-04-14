module prbs_3bit (
	input clk,
	output [2:0] q);reg [2:0] lfsr_reg = 3'b001;

	always @(posedge clk) begin
		lfsr_reg <= {lfsr_reg[1:0], lfsr_reg[2] ^ lfsr_reg[0]};
	end
	
	assign q = lfsr_reg;
	
endmodule