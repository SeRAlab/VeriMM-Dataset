module top_module(
	input clk,
	output reg [2:0] count);always @(posedge clk)
	if (count == 3'b101) count <= 3'b000;
	else count <= count + 1;

endmodule