module top_module(rst,clk,transmit,done,ss);input rst; 
  input clk; 
  input transmit; 
  input done; 
  output ss; 
  reg ss = 1'b1; 
  always @(posedge clk) 
  begin: ssprocess 
  begin 
  if (rst == 1'b1) 
  ss <= 1'b1; 
  else if (transmit == 1'b1) 
  ss <= 1'b0; 
  else if (done == 1'b1) 
  ss <= 1'b1; 
  end 
  end 
 endmodule