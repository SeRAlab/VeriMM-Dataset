module top_module(
	input clk,
	input enable,
	input reset,
	output reg [15:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 16'b1111111111111111;
	else if (enable)
		q <= q - 1;
end
endmodule