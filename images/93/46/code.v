module top_module(
	input clk,
	input set,
	output reg [3:0] q);always @(posedge clk)
	if (set) q <= 4'b1111;

endmodule