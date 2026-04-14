module fibonacci_lfsr_5bit_with_enable (
	input clk,
	input reset,
	input enable,
	output reg [4:0] lfsr);

	wire feedback = lfsr[4] ^ lfsr[2];

	always @(posedge clk) begin
		if (reset) begin
			lfsr <= 5'b00101; // Known initial value
		end else if (enable) begin
			lfsr <= {lfsr[3:0], feedback};
		end
	end
	
endmodule