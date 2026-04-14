module top_module(input PWRDN, output reg CLKOUT);parameter PWRDN_EN = 0; 
  parameter AUTO_PWRDN = 0; 
  parameter OUT_DIV = 1; 
  initial CLKOUT = 0; 
  always begin 
  if(PWRDN) 
  CLKOUT = 0; 
  else begin 
  #289017; 
  CLKOUT = ~CLKOUT; 
  end 
  end 
 endmodule