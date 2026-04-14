module binary_to_gray (
	input clk,
	input [3:0] binary_in,
	output reg [3:0] gray_out);always @(posedge clk)
		gray_out <= (binary_in >> 1) ^ binary_in;

endmodule