module top_module(a,b,y);input [3:0] a,b;
output reg y;

always @ (*) 
	begin
	if (a==b) y=1;
	
	else y=0;
	end
	
endmodule