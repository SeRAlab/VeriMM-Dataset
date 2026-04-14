module top_module (
	input clk,
	input a,
	input b,
	output reg y,
	output reg state);reg h;
	always @(posedge clk)
		h <= a&b | h&~a;

	assign y = h;
	assign state = h;
			
endmodule