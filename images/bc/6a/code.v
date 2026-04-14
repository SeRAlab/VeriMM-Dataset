module top_module(	s,
			co,
			a,
			b,
			ci	);output	[3:0]	s;	
output		co; 	

input	[3:0]	a;	
input	[3:0]	b;	
input		ci;	

assign		{co, s} = a + b + ci;endmodule