module gray_code_counter(
	input clk,
	input reset,
	input enable,
	output [3:0] gray_count);reg [3:0] binary_count;
wire [3:0] gray_code;

	assign gray_code = (binary_count >> 1) ^ binary_count;

	always @(posedge clk)
		if (reset) binary_count <= 4'b0000;
		else if (enable) binary_count <= binary_count + 1;

	assign gray_count = gray_code;

endmodule