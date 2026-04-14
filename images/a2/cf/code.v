module top_module (
	input clk,
	input [7:0] data_in,
	output reg data_out);reg [2:0] bit_pos;

always @(posedge clk) begin
		data_out <= data_in[bit_pos];
		bit_pos <= bit_pos + 1;
	end
	
endmodule