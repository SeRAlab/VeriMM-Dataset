module top_module (
	input clk,
	input rst,
	input en, 
	output reg [2:0] t);always @(posedge clk or posedge rst)
	if (rst)
		t <= 0;
	else if (en)
		t <= t + 1'b1;
	else
		t <= t;

endmodule