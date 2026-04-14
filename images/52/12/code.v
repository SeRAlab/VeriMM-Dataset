module top_module(input PWRDN, output reg CLKOUT_HARDIP, output reg CLKOUT_FABRIC);parameter PWRDN_EN = 0; 
  parameter AUTO_PWRDN = 0; 
  parameter HARDIP_DIV = 1; 
  parameter FABRIC_DIV = 1; 
  initial CLKOUT_HARDIP = 0; 
  initial CLKOUT_FABRIC = 0; 
  always begin 
  if(PWRDN) begin 
  CLKOUT_HARDIP = 0; 
  CLKOUT_FABRIC = 0; 
  end 
  else begin 
  #18.518; 
  CLKOUT_HARDIP = ~CLKOUT_HARDIP; 
  CLKOUT_FABRIC = ~CLKOUT_FABRIC; 
  end 
  end 
 endmodule