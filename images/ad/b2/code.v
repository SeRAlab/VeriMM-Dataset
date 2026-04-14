module johnson_counter_16bit(
	input clk,
	input rst_n,
	output reg [15:0] johnson_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			johnson_out <= 16'b0; // Reset to all zeros
		else
			johnson_out <= {johnson_out[14:0], ~johnson_out[15]};
	end

endmodule