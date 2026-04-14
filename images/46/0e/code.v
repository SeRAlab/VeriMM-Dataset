module top_module(NumIn,Num);input [31:0] NumIn;
output reg[31:0] Num;
integer i = 0;
always@(NumIn)
begin  
    Num = 32; 
    for(i = 31;i >= 0;i = i-1) 
       if(NumIn[i] == 1'b1 && Num == 32) 
            Num = 31 - i; 
end

endmodule