module top_module(clk, value, result);input clk; 
  input value; 
  output result; 
  reg Internal; 
  assign result = Internal ^ clk; 
  always @(posedge clk) 
  Internal <= #1 value; 
 endmodule