module lfsr_12bit_with_enable (
	input clk,
	input reset,
	input enable,
	output reg [11:0] lfsr);

	wire feedback = lfsr[11] ^ lfsr[10] ^ lfsr[9] ^ lfsr[0];

	always @(posedge clk) begin
		if (reset) begin
			lfsr <= 12'b1; // Initial value, can be any non-zero value
		end else if (enable) begin
			lfsr <= {lfsr[10:0], feedback};
		end
	end
	
endmodule