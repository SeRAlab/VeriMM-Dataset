module top_module (
	input clk,
	input t,
	output reg q);always @(posedge clk)
	if (t)
		q <= ~q;
	else
		q <= q;
		
endmodule