module top_module(
	input clk,
	input reset,
	output [5:0] count);reg [5:0] counter;

always @(posedge clk or posedge reset)
	if (reset)
		counter <= 6'b111111;
	else
		counter <= counter - 1;

assign count = counter;

endmodule