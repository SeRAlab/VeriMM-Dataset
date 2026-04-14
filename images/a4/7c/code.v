module top_module(c, r, q, cout);input c, r;
	output reg[1:0] q;
	output reg cout;
	always @(posedge c)
		if (r)
			{cout, q} <= 0;
		else
			{cout, q} <= q + 1'b1;
endmodule