module top_module(a0,a1,c,s);input a0,a1,s;
	output c;
	assign c=(s&a1)|((~s)&a0)|(a0&a1);
endmodule