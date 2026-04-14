module top_module(in1,in2,signIfComp);input in1,in2;
output reg signIfComp;
always@(in1 or in2)
begin
if(in1>in2)
signIfComp=1;
else if(in2>in1)
signIfComp=0;
else
signIfComp=1;
end
endmodule