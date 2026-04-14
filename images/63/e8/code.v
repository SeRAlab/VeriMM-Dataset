module top_module(en,s0,s1,y0,y1);input en,s0,s1;
	output y0,y1;
	assign y0=en&(~s0); assign y1=en&s1;
endmodule