module top_module(p,g,cin,c);input [1:0] p, g;
	input cin;
	output [2:1] c;

	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);endmodule