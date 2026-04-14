module top_module(x, y, s, cout);input [1:0]x;
	input [1:0]y;
	output s;
	output [1:0]cout;

	assign {s, cout} = x[1:0] + y[1:0];endmodule