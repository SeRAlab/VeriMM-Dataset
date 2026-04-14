module top_module(input wire EX_MemRead,input wire [4:0] rs,input wire [4:0] rt,input wire [4:0] EX_rt,output reg Stall);always @* 
  if (EX_MemRead && ((EX_rt == rs) || (EX_rt == rt))) begin 
  Stall = 1; 
  end 
  else begin 
  Stall = 0; 
  end 
 endmodule