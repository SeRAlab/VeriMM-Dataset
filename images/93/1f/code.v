module counter (
	input clk,
	input en,
	output reg [2:0] q);always @(posedge clk)
	if (en)
		if (q == 7)
			q <= 0;
		else
			q <= q + 1'b1;
	else
		q <= q;
		
endmodule