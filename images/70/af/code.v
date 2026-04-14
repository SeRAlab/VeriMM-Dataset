module top_module(a,b,c,s);input a,b,c;
	output s;
	assign s=(~c&a)|(c&b);endmodule