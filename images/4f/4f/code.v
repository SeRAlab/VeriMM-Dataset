module top_module(input clock, write, reset,input [3:0] address,input [15:0] writeData,output [15:0] data);reg [15:0] out = 16'b0; 
  always @ (posedge clock) begin 
  out = 16'b0; 
  end 
  assign data = out; 
 endmodule