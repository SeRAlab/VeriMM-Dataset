module top_module(
	input clk,
	input reset,
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	output reg [15:0] sum);always @(posedge clk) begin
		if (reset)
			sum <= 16'b0000000000000000;
		else
			sum <= a + b + c;
	end
endmodule