module top_module(a,b,s1,s2,sn,ex1,clk,out,ex2,sn3,sn4,s,sr1);input [23:0]a,b;
input[7:0]ex1;
input s1,s2,clk,sn;
output reg [23:0]ex2;
output reg[24:0]out;
output reg s,sn3,sn4,sr1;
always@(posedge clk)
begin
ex2=ex1;
sr1=sn;
sn3=s1;
sn4=s2;
s=s1^s2;
if(s)
begin
out=a+b;
end
else
begin
out=a+b;
end
end
endmodule