module d_flip_flop(
	input clk,
	input enable,
	input d,
	output reg q);
	
always @(posedge clk)
	if (enable)
		q <= d;

endmodule