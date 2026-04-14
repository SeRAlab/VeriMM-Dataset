module top_module(input d,clk,pre,output reg q);initial q <= 1'b0; 
  always @(negedge clk or posedge pre) 
  if (pre) q <= 1'b1; 
  else q <= d; 
 endmodule