module top_module(q,clk,d0,d1);input clk,d0,d1; 
 output [1:0] q; 
 reg [1:0] q; 
  always @(posedge clk) 
  q <= {d1,d0}; 
 endmodule