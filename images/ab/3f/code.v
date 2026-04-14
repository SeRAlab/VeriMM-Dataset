module top_module(a7,a6,a5,a4,a3,a2,a1,a0,s,y);parameter WIDTH = 8; 	
input [WIDTH-1:0] a7,a6,a5,a4,a3,a2,a1,a0;
input [2:0] s; 
output reg [WIDTH-1:0] y; 
	
always @(*)  
begin
if	(s == 3'b000)				
y <= a0;
else if (s == 3'b001) 
y <= a1;
else if (s == 3'b010) 
y <= a2;
else if (s == 3'b011) 
y <= a3;
else if (s == 3'b100) 
y <= a4;
else if (s == 3'b101) 
y <= a5;
else if (s == 3'b110) 
y <= a6;
else if (s == 3'b111) 
y <= a7;
end
endmodule