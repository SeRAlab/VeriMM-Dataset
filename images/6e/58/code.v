module top_module(a,b,s);input a;
	input b;
	
	output reg s;
	
	
	always @ (a,b)		
	begin						
		s = a & b;			
	end
	
endmodule