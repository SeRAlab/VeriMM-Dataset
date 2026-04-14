module top_module(input d,clk,pre,output reg q);initial q <= 0; 
  always @(posedge clk) 
  if (pre) q <= 1'b1; 
  else q <= d; 
 endmodule