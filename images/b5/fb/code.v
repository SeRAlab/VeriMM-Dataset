module top_module(input d,clk,output reg q);initial q <= 1'b0; 
  always @(negedge clk) q <= d; 
 endmodule