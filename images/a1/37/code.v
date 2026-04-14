module top_module(input clk,input en,output [7:0] R);wire [7:0] a, c; 
 reg [7:0] b, d; 
 assign a = (en) ? ({ a[6:0], a[7] } ^ a ^ { a[0], a[7:1] } ^ 8'h80) : a; 
 always @(posedge clk) 
 begin 
  b <= a; 
 end 
 assign c = (d & 8'h96) ^ { d[6:0], 1'b0 } ^ { 1'b0, d[7:1] } ^ b; 
 always @(posedge clk) 
 begin 
  d <= (en) ? c : d; 
 end 
 assign R = d; 
 endmodule