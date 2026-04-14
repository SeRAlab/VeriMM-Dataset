module top_module(input [2:0] immediate,
              output reg[7:0] extended
    );always @(immediate)begin
  if(immediate[2]==1)
   begin 
    extended[7:3]=5'b11111;
    extended[2:0]=immediate;
   end
   
   if(immediate[2]==0)begin 
   extended[7:3]=5'b00000;
   extended[2:0]=immediate;
   end
   end
   
    
endmodule