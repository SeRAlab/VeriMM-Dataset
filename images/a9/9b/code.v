module top_module(A, B, C, X, Y);parameter WIDTH = 1;

	input [WIDTH-1:0] A, B, C;
	output [WIDTH-1:0] X, Y;

	wire [WIDTH-1:0] t1, t2, t3;

	assign t1 = A ^ B, t2 = A & B, t3 = C & t1;
	assign Y = t1 ^ C, X = t2 | t3;
endmodule