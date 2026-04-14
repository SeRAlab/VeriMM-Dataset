module top_module( p, g,cin, gG, gP,c);input [2:0] p, g;
	input cin;
	output gG, gP;
	output [2:1] c;

	assign gG = (g[0] & p[1] & p[2])|(g[1]&p[2])|g[2];
	assign gP = p[0] & p[1] & p[2];
	
	assign c[1] = g[0]|(p[0] & cin);
	assign c[2] = g[1]|(p[1] & g[0])|(p[1] & p[0] & cin);endmodule