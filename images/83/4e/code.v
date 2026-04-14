module top_module (
	input clk,
	input h, 
	output reg [2:0] r);always @(posedge clk)
		if (h)
			r <= 3;
		else if (r == 6)
			r <= 0;
		else
			r <= r + 1'b1;

endmodule