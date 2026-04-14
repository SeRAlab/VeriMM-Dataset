module top_module(d, r, clk, q);input d, r, clk;
	output reg q;
	
	always @(posedge clk)
		if(r == 0)
			q <= 0;
		else
			q <= d;endmodule