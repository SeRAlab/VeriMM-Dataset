module top_module(x,clk, a, y);input clk; 
  input a, y; 
  output reg x ; 
  always @(posedge clk) begin 
  x <= a & y; 
  end 
 endmodule