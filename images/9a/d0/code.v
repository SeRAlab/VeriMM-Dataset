module top_module(y,s1,s0,i3,i2,i1,i0);input i0,i1,i2,i3;
output reg y;
input s1,s0;
always @(s1,s0,i0,i1,i2,i3)
begin
if(s0==0 && s1==0)
y=i0;
else if(s0==0 && s1==1)
y=i1;
else if(s0==1 && s1==0)
y=i2;
else if(s0==1 && s1==1)
y=i3;
end
endmodule