module top_module(a, b, s, f);input a,b,s;
	output f;
	assign f = s? a:b;endmodule