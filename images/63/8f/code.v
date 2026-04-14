module top_module(a, b, cin, g, p, s, cout);input a, b, cin;
	output g, p, s, cout;
	
	assign g = a & b;
	assign p = a ^ b;
	assign cout = g | (cin & p);
	assign s = p ^ cin;endmodule