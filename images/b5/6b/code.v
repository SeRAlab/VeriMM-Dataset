module top_module (
	input clk,
	input x,
	input y,
	output reg z,
	output reg state);reg k;
	always @(posedge clk)
		k <= x&y | k&~x;

	assign z = k;
	assign state = k;
			
endmodule