module top_module (
	input clk,
	input rst,
	output reg [2:0] t);always @(posedge clk or posedge rst)
	if (rst)
		t <= 0;
	else
		t <= t + 1'b1;

endmodule