module top_module(
	input clk,
	input reset,
	input enable,
	input [1:0] data_in,
	output reg [1:0] data_out);always @(posedge clk or posedge reset) begin
	if (reset)
		data_out <= 2'b00;
	else if (enable)
		data_out <= data_in;
end

endmodule