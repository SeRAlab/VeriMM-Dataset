module top_module(clk, enable, clk_gated);input clk; 
  input enable; 
  output clk_gated; 
  wire clk_gated; 
  reg enable_q; 
  always @(clk, enable) 
  begin 
  if(clk == 0) 
  enable_q <= enable; 
  end 
  assign clk_gated = clk & enable_q; 
 endmodule