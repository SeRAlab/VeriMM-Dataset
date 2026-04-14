module top_module (
	input clk,
	input m,
	input n,
	output reg t,
	output reg state);reg g;
	always @(posedge clk)
		g <= m & n | g & ~m;

	assign t = g;
	assign state = g;
			
endmodule