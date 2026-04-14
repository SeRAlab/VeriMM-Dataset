module top_module(
	input clk,
	input reset_n,
	input [23:0] a,
	input [23:0] b,
	output reg [23:0] sum);always @(posedge clk or negedge reset_n) begin
	if (!reset_n)
		sum <= 24'b0;
	else
		sum <= a + b;
end
endmodule