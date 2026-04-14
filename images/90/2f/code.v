module top_module(s0,s1,s2,s3,i0,i1,a);input i0,i1;
input a;
output s0,s1,s2,s3;

reg temp1=0;
reg temp2=0;
reg temp3=0;
reg temp4=0; 

always @(i0,i1,a)
begin
if (i0==1'b0 && i1==1'b0 && a==1)
     temp1=1;
else if (i0==1'b1 && i1==1'b0 && a==1)
     temp2=1;
else if (i0==1'b0 && i1==1'b1 && a==1)
     temp3=1;
else if (i0==1'b1 && i1==1'b1 && a==1)
     temp4=1;
else temp1=0;
     temp2=0;
     temp3=0;
     temp4=0;
end
      
 assign s0=temp1;
 assign s1=temp2;
 assign s2=temp3;
 assign s3=temp4;endmodule