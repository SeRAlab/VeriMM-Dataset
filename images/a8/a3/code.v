module top_module(out,clk, in, reset);input clk; 
  input in; 
  output out; 
  input reset; 
  reg out_reg; 
  always @ (posedge clk or posedge reset) 
  if(reset) 
  out_reg <= 1'b0; 
  else 
  out_reg <= in; 
  assign out = in ^ out_reg; 
 endmodule