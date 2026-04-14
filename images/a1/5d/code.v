module gray_code_counter_4bit(
	input clk,
	input rst_n,
	output reg [3:0] gray_out
);

	reg [3:0] binary_count;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			binary_count <= 4'b0; // Reset to zero
			gray_out <= 4'b0; // Reset Gray code output to zero
		end else begin
			binary_count <= binary_count + 1;
			gray_out <= (binary_count >> 1) ^ binary_count; // Convert to Gray code
		end
	end

endmodule