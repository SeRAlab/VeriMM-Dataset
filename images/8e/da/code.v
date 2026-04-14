module lfsr_10bit(
	input clk,
	input rst_n,
	output reg [9:0] lfsr_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			lfsr_out <= 10'b0000000001; // Non-zero initial value
		else begin
			lfsr_out <= {lfsr_out[8:0], lfsr_out[9] ^ lfsr_out[6]};
		end
	end

endmodule