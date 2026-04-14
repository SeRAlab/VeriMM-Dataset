module top_module(a,b,p,q);input a,b;
output p,q;

	assign p = a;
	assign q = a ^ b;

endmodule