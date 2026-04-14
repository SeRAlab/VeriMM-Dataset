module top_module(a,b,cin,out);input [3:0] a;
	input [3:0] b;
	input cin;
	output [3:0] out;

	assign out = a + b + cin;

endmodule