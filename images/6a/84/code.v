module top_module(ABLK_PG,ABLK_RESETn,ABLK_EN,ABLK_CONFIG_0,ABLK_CONFIG_1);input ABLK_PG; 
  input ABLK_RESETn; 
  input ABLK_EN; 
  input [3:0] ABLK_CONFIG_0; 
  input [3:0] ABLK_CONFIG_1; 
  always @(ABLK_PG) begin 
  $write("%c[1;34m",27); 
  $display("ablk Input ABLK_PG Has been changed to:%x", ABLK_PG); 
  $write("%c[0m",27); 
  end 
  always @(ABLK_RESETn) begin 
  $write("%c[1;34m",27); 
  $display("ablk Input ABLK_RESETn Has been changed to:%x", ABLK_RESETn); 
  $write("%c[0m",27); 
  end 
  always @(ABLK_EN) begin 
  $write("%c[1;34m",27); 
  $display("ablk Input ABLK_EN Has been changed to:%x", ABLK_EN); 
  $write("%c[0m",27); 
  end 
  always @(ABLK_CONFIG_0) begin 
  $write("%c[1;34m",27); 
  $display("ablk Input ABLK_CONFIG_0 Has been changed to:%x", ABLK_CONFIG_0); 
  $write("%c[0m",27); 
  end 
  always @(ABLK_CONFIG_1) begin 
  $write("%c[1;34m",27); 
  $display("ablk Input ABLK_CONFIG_1 Has been changed to:%x", ABLK_CONFIG_1); 
  $write("%c[0m",27); 
  end 
 endmodule