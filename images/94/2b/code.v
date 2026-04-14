module lfsr_fibonacci (
	input clk,
	input reset,
	output reg [11:0] lfsr);

	always @(posedge clk) begin
		if (reset)
			lfsr <= 12'hACE; // initial seed
		else
			lfsr <= {lfsr[10:0], lfsr[11] ^ lfsr[10] ^ lfsr[8]};
	end
	
endmodule