module top_module(clk, rst, nReset, al);input clk, rst, nReset; 
  output reg al; 
  reg cmd_stop; 
  always @(posedge clk or negedge nReset) 
  if (~nReset) 
  cmd_stop <= #1 1'b0; 
  else if (rst) 
  cmd_stop <= #1 1'b0; 
  always @(posedge clk or negedge nReset) 
  if (~nReset) 
  al <= #1 1'b0; 
  else if (rst) 
  al <= #1 1'b0; 
  else 
  al <= #1 ~cmd_stop; 
 endmodule