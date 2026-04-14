module top_module(clk, rst, clk_ena, d);input clk, rst, clk_ena; 
  output d; 
  reg tmp; 
  always @(posedge clk or posedge rst) 
  begin 
  if(rst) 
  tmp <= 'b0; 
  else if(clk_ena) 
  tmp <= 'b1; 
  end 
  assign d = tmp; 
 endmodule