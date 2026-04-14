module top_module(a, b, cout, sum);input	a, b;
	output	cout, sum;
	assign {cout,sum} = a + b;
endmodule