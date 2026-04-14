module top_module(sum, co, a, b, ci);output	[3:0]sum;
	output	co;
	input	[3:0]a,b;
	input	ci;
	
	assign	{co,sum}	=a+b+ci;
endmodule