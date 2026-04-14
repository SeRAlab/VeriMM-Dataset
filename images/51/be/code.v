module top_module(reset, work, clk, wait_time);input clk,work,reset; 
 output [11:0] wait_time; 
 reg [11:0] wait_time; 
 reg [5:0] i; 
 always @ (posedge clk or negedge reset) 
 begin 
  if(!reset) 
  begin 
  wait_time <= 0; 
  i <= 0; 
  end 
  else if (work == 0) 
  begin 
  if(i >= 4) 
  begin 
  wait_time <= wait_time +1; 
  i <= 0; 
  end 
  else i <= i+1; 
  end 
 end 
 endmodule