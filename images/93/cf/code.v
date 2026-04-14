module top_module (
	input clk,
	input j,
	input k, 
	output reg q);always @(posedge clk)
	if (j & k)
		q <= ~q;
		
endmodule