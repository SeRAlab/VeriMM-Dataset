module top_module (
	input clk,
	input a,
	input b,
	output reg c,
	output reg state);reg l;
	always @(posedge clk)
		l <= a&b | l&~a;

	assign c = l;
	assign state = l;
			
endmodule