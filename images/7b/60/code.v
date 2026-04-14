module register_16bit(
	input clk,
	input rst_n,
	input load_en,
	input [15:0] data_in,
	output reg [15:0] data_out
);

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_out <= 16'b0;
		end
		else if (load_en) begin
			data_out <= data_in;
		end
	end

endmodule