module flip_flop(
	input clk,
	output reg q);always @(posedge clk)
	q <= ~q;

endmodule