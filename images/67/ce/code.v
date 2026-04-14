module top_module(i1,i2,cin,cout,s);input i1,i2,cin;
	output cout,s;
	assign s = i1^i2^cin;
	assign cout = (i1&i2)|(cin&(i1^i2));
endmodule