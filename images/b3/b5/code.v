module top_module(input wire clk,input wire [ 7:0] a0,input wire [ 7:0] b0,output reg [15:0] z0,input wire [ 7:0] a1,input wire [ 7:0] b1,output reg [15:0] z1);always @(posedge clk) 
  z0 <= a0 * b0; 
  always @(posedge clk) 
  z1 <= a1 * b1; 
 endmodule