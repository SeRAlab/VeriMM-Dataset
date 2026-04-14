module top_module(cout, out, c, a, b);input c;
	input b;
	input a;
	
	output cout;
	output out;
	
	assign cout = (b & a) | (a & c) | (b & c);
	assign out = (a & ~b & ~c) |
					 (~a & b & ~c)  |
					 (~a & ~b & c)  |
					 (a & b & c);endmodule