module top_module(input wire clk,input wire clr,input wire [ 7:0] A,input wire [ 7:0] B,output reg [15:0] Z);reg [15:0] acc; 
  assign Z = (clr) ? (A * B) : (acc + (A * B)); 
  always @(posedge clk) 
  acc <= Z; 
 endmodule