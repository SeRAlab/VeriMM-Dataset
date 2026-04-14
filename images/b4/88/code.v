module gray_code_counter_3bit(
	input clk,
	input rst_n,
	output reg [2:0] gray_code
);

	reg [2:0] binary_count;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			binary_count <= 3'b000;
			gray_code <= 3'b000;
		end
		else begin
			binary_count <= binary_count + 1'b1;
			gray_code <= (binary_count >> 1) ^ binary_count;
		end
	end

endmodule