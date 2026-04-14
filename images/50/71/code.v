module binary_to_gray(
	input clk,
	input rst_n,
	input [7:0] binary_in,
	output reg [7:0] gray_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			gray_out <= 8'b0;
		else begin
			gray_out[7] <= binary_in[7];
			gray_out[6] <= binary_in[7] ^ binary_in[6];
			gray_out[5] <= binary_in[6] ^ binary_in[5];
			gray_out[4] <= binary_in[5] ^ binary_in[4];
			gray_out[3] <= binary_in[4] ^ binary_in[3];
			gray_out[2] <= binary_in[3] ^ binary_in[2];
			gray_out[1] <= binary_in[2] ^ binary_in[1];
			gray_out[0] <= binary_in[1] ^ binary_in[0];
		end
	end
	
endmodule