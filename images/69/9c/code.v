module ring_counter_12bit(
	input clk,
	input rst_n,
	output reg [11:0] ring_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			ring_out <= 12'b0000_0000_0001; // Initial value with a single '1'
		else
			ring_out <= {ring_out[10:0], ring_out[11]};
	end

endmodule