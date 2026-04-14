module top_module(clkout,clkin );output clkout; 
  input clkin; 
  assign clkout = ~( clkin ); 
 endmodule