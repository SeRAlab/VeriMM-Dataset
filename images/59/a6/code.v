module johnson_counter_8bit(
	input clk,
	input rst_n,
	output reg [7:0] johnson_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			johnson_out <= 8'b0000_0000;
		else
			johnson_out <= {johnson_out[6:0], ~johnson_out[7]};
	end

endmodule