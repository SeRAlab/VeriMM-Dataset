module top_module (
	input clk,
	input x,
	input y,
	output reg q,
	output reg state);reg d;
	always @(posedge clk)
		d <= x^y | x&d | y&d;
	
	assign q = x^y^d;
	assign state = d;
			
endmodule