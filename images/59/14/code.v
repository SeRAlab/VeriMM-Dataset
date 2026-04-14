module top_module(cin, x, y, s, cout);input cin, x, y;
	output s, cout;
	assign s = x^y^cin;
	assign cout = (x&y)|(x&cin)|(y&cin);endmodule