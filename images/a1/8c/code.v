module top_module(reset,clka,out);input reset; 
 input clka; 
 output out; 
 reg out; 
 always @(posedge clka or posedge reset) 
  if(reset) 
  out = 0; 
  else 
  out = ~out; 
 endmodule