module top_module( a,b,cin,c, sum);input [15:0] a, b;
	input cin;
	input [15:1]c;
	output [15:0] sum;
	assign sum = a^ b^{c,cin};endmodule