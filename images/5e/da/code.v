module top_module(
	input clk,
	input data_en_in,
	input [15:0]data_in,
	output reg data_en,
	output reg [15:0]data_out
	);always @(posedge clk)
begin
	data_en <= data_en_in;
	data_out <= data_in;
end

endmodule