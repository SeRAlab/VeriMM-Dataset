module top_module(
	input clk,
	input reset,
	input [7:0] a,
	input [7:0] b,
	output reg [15:0] product);always @(posedge clk) begin
	if (reset)
		product <= 16'b0;
	else
		product <= a * b;
end
endmodule