module top_module(gated_clk, clk, clken);output gated_clk; 
  input clk, clken; 
  reg clken_r ; 
  assign gated_clk = clk & clken_r ; 
  always @(negedge clk) 
  clken_r <= clken; 
 endmodule