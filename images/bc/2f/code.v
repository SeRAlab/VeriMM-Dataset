module fibonacci_lfsr (
	input clk,
	input reset,
	output reg [7:0] lfsr);

	always @(posedge clk) begin
		if (reset)
			lfsr <= 8'b00000001; // Seed value
		else
			lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5]};
	end
	
endmodule