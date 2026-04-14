module top_module (
	input clk,
	input g, 
	output reg [2:0] w);always @(posedge clk)
		if (g)
			w <= 0;
		else if (w == 6)
			w <= 0;
		else
			w <= w + 1'b1;
			
endmodule