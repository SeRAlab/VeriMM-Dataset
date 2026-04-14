module tff(
	input clk,
	input reset_n,
	input t,
	output reg q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 0;
	else if (t)
		q <= ~q;

endmodule