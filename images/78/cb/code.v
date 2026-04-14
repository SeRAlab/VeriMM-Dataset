module top_module (
	input clk,
	input reset,
	output reg flag);

always @(posedge clk)
	if (reset)
		flag <= 1'b1;
	else
		flag <= ~flag;

endmodule