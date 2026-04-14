module top_module(input clk,input reset,input in,output p);reg [1:0] x; 
  always @(posedge clk or posedge reset) 
  if(reset) 
  x <= 0; 
  else 
  x <= { x[0], in }; 
  assign p = x[0] & !x[1]; 
 endmodule