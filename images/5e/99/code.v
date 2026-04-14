module top_module (
	input clk,
	input p,
	input q,
	output reg t,
	output reg state);reg g;
	always @(posedge clk)
		g <= p & q | g & ~p;

	assign t = g;
	assign state = g;
			
endmodule