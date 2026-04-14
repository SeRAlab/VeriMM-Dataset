module top_module (
	input clk,
	input a,
	input b,
	output reg y,
	output reg state);reg f;
	always @(posedge clk)
		f <= a&b | f&~a;

	assign y = f;
	assign state = f;
			
endmodule