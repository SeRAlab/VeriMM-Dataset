module top_module (
	input clk,
	input e, 
	output reg [2:0] u);always @(posedge clk)
		if (e)
			u <= 5;
		else if (u == 7)
			u <= 0;
		else
			u <= u + 1'b1;
			
endmodule