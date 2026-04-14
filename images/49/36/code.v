module top_module(
	input clk,
	output [3:0] count);reg [3:0] t_counter;

always @(posedge clk)
	t_counter <= t_counter + 1;

assign count = t_counter;

endmodule