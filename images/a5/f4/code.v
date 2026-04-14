module register_32bit_sync_rst(
	input clk,
	input rst,
	input load_en,
	input [31:0] data_in,
	output reg [31:0] data_out
);

	always @(posedge clk) begin
		if (rst) begin
			data_out <= 32'b0;
		end
		else if (load_en) begin
			data_out <= data_in;
		end
	end

endmodule