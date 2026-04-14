module top_module(
	input  [31:0] a, b,
	input         cin,
	output [31:0] y,
	output        cout
);assign {cout, y} = a + b + cin;endmodule