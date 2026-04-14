module shift_register_4bit(
	input clk,
	input rst_n,
	input shift_en,
	output reg [3:0] data_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_out <= 4'b0;
		end
		else if (shift_en) begin
			data_out <= data_out << 1;
		end
	end

endmodule