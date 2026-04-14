module top_module (
	input clk,
	input en, 
	output reg [2:0] t);always @(posedge clk)
	if (en)
		t <= t + 1'b1;
	else
		t <= t;

endmodule