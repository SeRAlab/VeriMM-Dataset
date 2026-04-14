module top_module (
	input clk,
	input x,
	input y,
	output reg z,
	output reg state);reg h;
	always @(posedge clk)
		h <= x&y | h&~x;

	assign z = h;
	assign state = h;
			
endmodule