module top_module (
	input clk,
	input d, 
	output reg [2:0] t);always @(posedge clk)
		if (d)
			t <= 1;
		else if (t == 4)
			t <= 0;
		else
			t <= t + 1'b1;
			
endmodule