module top_module(clk, set,qout,reset,light, cout);input clk,reset,light;
input [6:0] set;
output cout;
output [6:0] qout;
reg [6:0] qout = 0;
always @(negedge clk or posedge reset)
begin
if(reset == 1)
qout=0;
else 
begin

if(qout[6:0]==set)
        qout[6:0]=0;
   else if(light==1)    
   qout[6:0]=qout[6:0]+1;
end
end

assign cout=((qout[6:0]==set))?1:0;endmodule