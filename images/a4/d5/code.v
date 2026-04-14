module gray_code_counter(
	input clk,
	input reset,
	output reg [2:0] gray_code);

reg [2:0] binary_count;

always @(posedge clk) begin
	if (reset)
		binary_count <= 3'b000;
	else
		binary_count <= binary_count + 1;
end

always @(binary_count) begin
	gray_code = binary_count ^ (binary_count >> 1);
end

endmodule