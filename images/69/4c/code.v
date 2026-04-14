module top_module(input clock,input ready,input x,output reg y);always @(posedge clock) 
  y <= ready ? y | x : 0; 
 endmodule