module top_module(data,count);input [7:0]data;
output reg [3:0]count;
always@(data)
count_binary(data,count);
task count_binary;
input [7:0]data;
output [3:0]out;
integer i;
begin
out=0;
for(i=0;i<8;i=i+1) 
if(!data[i]) out=out+1;
end
endtask
endmodule