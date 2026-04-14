module top_module(clk, ena,seli, we,exp, d,result);input clk; 
 input ena; 
 input seli; 
 input we; 
 input [5:0] exp; 
 input [15:0] d; 
 output [15:0] result; 
 reg [15:0] result; 
 always@(posedge clk) 
  if (ena) 
  if (we) 
  result <= seli ? {10'h0, exp} : d; 
 endmodule