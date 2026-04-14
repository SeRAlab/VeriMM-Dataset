module top_module (
	input clk,
	input a,
	input b,
	output reg t,
	output reg state);reg g;
	always @(posedge clk)
		g <= a & b | g & ~a;

	assign t = g;
	assign state = g;
			
endmodule