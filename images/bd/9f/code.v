module top_module(a, b, equal);parameter n = 32;
input [n-1:0] a, b;
output reg equal;

always@*
begin
if(a==b)begin
equal=1;
end
else begin
equal=0;
end
end
 
endmodule