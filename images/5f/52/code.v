module top_module (
	input clk,
	input h, 
	output reg [2:0] s);always @(posedge clk)
		if (h)
			s <= 6;
		else if (s == 7)
			s <= 0;
		else
			s <= s + 1'b1;

endmodule