module top_module(m, x, y, s);input x;
	input y;
	input s;
	output m;
	assign m = s ? y : x;endmodule