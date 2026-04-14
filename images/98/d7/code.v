module top_module(a,b,agb,aeb,alb);parameter n=1;
input [n-1:0]  a, b;
output agb;
output  aeb;
output  alb;
reg  alb, agb,aeb;
	
always @(a or b)
		
begin	agb = 0; aeb =0 ; alb =0; 
		if(a==b)
         aeb=1;
	    else if(a>b)
	    agb=1;
		else
		    alb=1;
end

endmodule