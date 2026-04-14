module top_module(
input clk,rst,x,
output reg y);parameter s0=2'b00,s1=2'b01,s2=2'b10;
reg [1:0] cs,ns;

always @(posedge clk or negedge rst)
begin
if (rst==1'b0)  cs<=s0;
else            cs<=ns;
end

always @(x or cs)
begin
case(cs)
s0:begin
   if(x==1)  ns<=s1;
   else      ns<=s0;
   end
s1:begin
   if(x==0)  ns<=s2;
   else      ns<=s1;
   end
s2:begin
   if(x==1)  ns<=s1;
   else      ns<=s0;
   end
endcase
end

always @(x or cs)
begin
case(cs)
s0:y=0;
s1:y=0;
s2:if(x==0)  y=0;
   else      y=1;
endcase
end

endmodule