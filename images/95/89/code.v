module top_module (
	input clk,
	output reg [3:0] gray_code);

	reg [3:0] binary;

	always @(posedge clk) begin
		binary <= binary + 1;
		gray_code <= binary ^ (binary >> 1);
	end
endmodule