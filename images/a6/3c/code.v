module top_module(
	input clk,
	input [7:0] data_in,
	output [11:0] crc);reg [11:0] crc_reg;

	always @(posedge clk) begin
		crc_reg <= {crc_reg[10:0], data_in[7]} ^ (12'b110000000011 & {12{data_in[7]}});
	end

	assign crc = crc_reg;

endmodule