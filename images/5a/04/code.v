module top_module (
	input clk,
	input h, 
	output reg [2:0] v);always @(posedge clk)
		if (h)
			v <= 5;
		else if (v == 7)
			v <= 1;
		else
			v <= v + 1'b1;

endmodule