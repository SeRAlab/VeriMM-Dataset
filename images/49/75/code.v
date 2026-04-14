module top_module (
	input clk,
	input h, 
	output reg [2:0] t);always @(posedge clk)
		if (h)
			t <= 0;
		else if (t == 4)
			t <= 0;
		else
			t <= t + 1'b1;

endmodule