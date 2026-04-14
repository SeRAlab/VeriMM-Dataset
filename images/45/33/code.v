module top_module (
	input clk,
	input c, 
	output reg [2:0] s);always @(posedge clk)
		if (c)
			s <= 7;
		else if (s > 0)
			s <= s - 1'b1;
		else
			s <= 0;
			
endmodule