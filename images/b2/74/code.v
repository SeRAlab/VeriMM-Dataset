module top_module (
	input clk,
	input h, 
	output reg [2:0] z);always @(posedge clk)
		if (h)
			z <= 1;
		else if (z == 4)
			z <= 0;
		else
			z <= z + 1'b1;

endmodule