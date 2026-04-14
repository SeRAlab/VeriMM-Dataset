module top_module(a, b, cin, cout, s);input a, b, cin;
	output s, cout;
	assign s = a^b^cin;
	assign cout = (a&b) + (a & cin) + (b & cin);endmodule