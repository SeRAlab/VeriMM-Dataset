module top_module(Out, In);input [7:0] In;
output reg Out;
integer i = 0;
integer cnt = 0;

always@(In)
begin
for(i = 0; i < 8; i =i+1)
    begin
        if(In[i] == 1)
            cnt = cnt + 1;
    end
    if((cnt % 2) == 1) 
        Out = 1;
    else
        Out = 0;
    end
endmodule