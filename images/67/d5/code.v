module top_module (
	input clk,
	input r,
	input s,
	output reg t,
	output reg state);reg g;
	always @(posedge clk)
		g <= r&~s | g&~r;

	assign t = g;
	assign state = g;
			
endmodule