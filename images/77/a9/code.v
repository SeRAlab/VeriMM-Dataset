module t_flip_flop(
	input clk,
	input t,
	output reg q);initial
		q = 1'b0;
		
	always @(posedge clk)
		if (t)
			q <= ~q;
	
endmodule