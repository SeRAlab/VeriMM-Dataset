module down_counter(
	input clk,
	input reset,
	input enable,
	output reg [7:0] count);always @(posedge clk)
	if (reset)
		count <= 8'b11111111;
	else if (enable)
		count <= count - 1;

endmodule