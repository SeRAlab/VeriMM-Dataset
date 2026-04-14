module top_module( a ,b , s ,ci,co );input a ;
  wire a ;
  input b ;
  wire b ;
  input ci ;
 wire ci ;
 
reg s1,s2,s3;
 output co ;
 reg co ;
 output s ;
reg s;
always @(a or b or ci)
	begin
		s = (a^b)^ci;
		s1 = a&ci;
		s2 = b&ci;
		s3 = a&b;
		co = (s1|s2)|s3;
	end
endmodule