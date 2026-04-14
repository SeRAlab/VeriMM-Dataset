module top_module(a,b,sum,control);parameter size=16;
	input [size-1:0] a, b;
	input control;
	output [size-1:0] sum;
	assign sum = control ? (a + b) : (a - b);endmodule