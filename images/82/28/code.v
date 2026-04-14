module d_flip_flop(
	input clk,
	input reset_n,
	input d,
	output reg q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 1'b0;
	else
		q <= d;

endmodule