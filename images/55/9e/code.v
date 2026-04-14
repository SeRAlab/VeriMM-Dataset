module top_module (
	input clk,
	input u,
	input v,
	output reg t,
	output reg state);reg g;
	always @(posedge clk)
		g <= u & v | g & ~u;

	assign t = g;
	assign state = g;
			
endmodule