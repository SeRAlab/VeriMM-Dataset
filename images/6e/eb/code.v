module top_module(clk, hardreset, reset);input clk, hardreset; 
 output reset; 
 reg [3:0] reset_reg, next_reset_reg; 
 assign reset = reset_reg[3]; 
 initial reset_reg = 4'hF; 
 always @ (posedge clk or posedge hardreset) 
 begin 
  if (hardreset) 
  reset_reg = 4'hF; 
  else reset_reg = next_reset_reg; 
 end 
 always @* 
 begin 
  next_reset_reg = {reset_reg,1'b0}; 
 end 
 endmodule