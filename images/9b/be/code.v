module top_module(
	
	a			,
	b			,
	s			,
	
	
	y		

);input 		  a;
	input 		  b;
	input 		  s;
	
	
	
	
	output	reg		y;
	
	
	always @ (a,b,s)
	if(s==0)
		y=a;
	else 
		y=b;
	
endmodule