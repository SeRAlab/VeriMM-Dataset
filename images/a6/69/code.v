module d_flip_flop(
	input clk,
	input reset,
	input d,
	output reg q);always @(posedge clk or negedge reset)
	if (!reset)
		q <= 1'b0;
	else
		q <= d;
endmodule