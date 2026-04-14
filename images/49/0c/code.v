module top_module(
	input clk,
	input reset,
	output [11:0] count);reg [11:0] counter;

always @(posedge clk or posedge reset)
	if (reset)
		counter <= 12'b111111111111;
	else
		counter <= counter - 1;

assign count = counter;

endmodule