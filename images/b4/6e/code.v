module tff (
	input clk,
	input resetn,
	input t,
	output reg q);always @(posedge clk or negedge resetn)
		if (!resetn)
			q <= 0;
		else if (t)
			q <= ~q;

endmodule