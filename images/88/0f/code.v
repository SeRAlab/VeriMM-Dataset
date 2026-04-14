module top_module (
	input clk,
	input d,
	input e,
	output reg f,
	output reg state);reg k;
	always @(posedge clk)
		k <= d&e | k&~d;

	assign f = k;
	assign state = k;
			
endmodule