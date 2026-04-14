module top_module (
	input clk,
	input reset,
	input clk_enable,
	input [31:0] data_in,
	output reg [31:0] data_out);always @(posedge clk or posedge reset) begin
	if (reset)
		data_out <= 32'b0;
	else if (clk_enable)
		data_out <= data_in;
end

endmodule