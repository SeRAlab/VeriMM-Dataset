module top_module(clk, active, clk_gated);input clk; 
  input active; 
  output clk_gated; 
  wire clk_gated; 
  reg active_q; 
  always @(clk, active) 
  begin 
  if(clk == 0) 
  active_q <= active; 
  end 
  assign clk_gated = clk & active_q; 
 endmodule