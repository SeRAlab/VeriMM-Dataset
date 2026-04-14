module top_module (
	input clk,
	input b, 
	output reg [2:0] r);always @(posedge clk)
		if (b)
			r <= 3;
		else if (r > 0)
			r <= r - 1'b1;
		else
			r <= 0;
			
endmodule