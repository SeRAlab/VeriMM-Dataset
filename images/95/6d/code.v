module top_module(p, g,cin,c);input p,g;
	input cin;
	output c;

	assign c = g|(p & cin);endmodule