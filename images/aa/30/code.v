module binary_decoder(
	input clk,
	input rst,
	input [1:0] binary_in,
	output reg [3:0] one_hot_out
);

	always @(posedge clk or posedge rst) begin
		if (rst)
			one_hot_out <= 4'b1111;
		else begin
			case (binary_in)
				2'b00: one_hot_out <= 4'b1110;
				2'b01: one_hot_out <= 4'b1101;
				2'b10: one_hot_out <= 4'b1011;
				2'b11: one_hot_out <= 4'b0111;
				default: one_hot_out <= 4'b1111;
			endcase
		end
	end

endmodule