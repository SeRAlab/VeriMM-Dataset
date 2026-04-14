module top_module( 
input [3:0] Data1 , 
input [3:0] Data2 ,
output reg [3:0] SubOut ) ;always @ (*) 
	SubOut <= (Data1 - Data2) ;endmodule