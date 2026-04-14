module top_module (
	input clk,
	input enable, 
	output reg q);always @(posedge clk)
	if (enable)
		q <= ~q;
		
endmodule