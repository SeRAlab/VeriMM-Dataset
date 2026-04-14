module top_module(
	input clk,
	input set,
	output reg [6:0] q);always @(posedge clk)
	if (set) q <= 7'b1111111;

endmodule