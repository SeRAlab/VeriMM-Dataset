module top_module(input clk, input d, output q, input rst);reg down; 
 assign q = d & !down; 
 always @(posedge clk) 
 begin 
  if(q) 
  down <= 1; 
  if(!d) 
  down <= 0; 
  if(rst) 
  down <= 0; 
 end 
 endmodule