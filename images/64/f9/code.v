module top_module (
	input clk,
	input h, 
	output reg [2:0] u);always @(posedge clk)
		if (h)
			u <= 7;
		else if (u == 3)
			u <= 0;
		else
			u <= u + 1'b1;

endmodule