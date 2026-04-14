module top_module(y, b, a);output y;
	input b, a;
	
	assign y= (a == b) ? 1 : 0;
endmodule