module top_module(input wire clk,input wire [ 7:0] A,input wire [ 7:0] B,output wire [15:0] Z);reg [15:0] acc; 
  assign Z = acc + (A * B); 
  always @(posedge clk) 
  acc <= Z; 
 endmodule