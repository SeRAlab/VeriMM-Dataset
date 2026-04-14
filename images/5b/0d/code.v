module top_module (
	input clk,
	input d, 
	output reg q);always @(posedge clk)
		if (d)
			q <= 1;
		else
			q <= 0;
			
endmodule