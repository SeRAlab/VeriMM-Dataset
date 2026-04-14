module top_module(ref_clk,txp,rxp);output ref_clk; 
  input txp; 
  output rxp; 
  reg clk_tmp; 
  initial 
  clk_tmp <= 1'b0; 
  always 
  #4 clk_tmp <= ~clk_tmp; 
  reg reconfig_clk_tmp; 
  initial 
  reconfig_clk_tmp <= 1'b0; 
  always 
  #20 reconfig_clk_tmp <= ~reconfig_clk_tmp; 
  assign ref_clk = clk_tmp; 
  assign rxp=txp; 
 endmodule