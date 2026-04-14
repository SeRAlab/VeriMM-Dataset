module top_module(prod,a,b);output prod;
	
	input a,b;
	
	reg prod;
	
	wire a,b;
	
	always @(a or b)
		prod = a*b;
		
endmodule