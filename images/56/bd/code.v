module top_module (
	input clk,
	input h, 
	output reg [2:0] w);always @(posedge clk)
		if (h)
			w <= 4;
		else if (w == 7)
			w <= 0;
		else
			w <= w + 1'b1;

endmodule