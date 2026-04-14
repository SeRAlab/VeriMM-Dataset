module top_module (
	input clk,
	input x,
	input y,
	output reg t,
	output reg state);reg g;
	always @(posedge clk)
		g <= x & y | g & ~x;

	assign t = g;
	assign state = g;
			
endmodule