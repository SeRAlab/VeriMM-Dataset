module top_module(c,y,clk);output[6:0] c; 
input[6:0] y; 
input clk;
reg[6:0] c,c_buf,buffer;
reg temp;
reg s0,s1,s2; 
reg e; 
integer i;



























always @(posedge clk)
begin
for (i=0; i<3; i=i+1)
c[i]=c_buf[i];
end
always @(posedge clk)
begin
for (i=2; i<7; i=i+1)
c[i]= c_buf[i];
end
endmodule