module top_module(a,b,y);input [15:0] a;
input [15:0] b; 

output reg [31:0] y; 


always @ (a or b) 
begin

if(b < 3072 )
y= a <<2;
else
y= a <<12;

end


     
endmodule