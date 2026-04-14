module jkff (
	input clk,
	input resetn,
	input j,
	input k,
	output reg q);always @(posedge clk or negedge resetn)
		if (!resetn)
			q <= 0;
		else if (j & k)
			q <= ~q;
		else if (j)
			q <= 1;
		else if (k)
			q <= 0;

endmodule