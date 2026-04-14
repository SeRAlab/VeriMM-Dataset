module top_module(input clock, write, reset,input [15:0] writeData,output [15:0] data);reg [15:0] basePointer; 
  always @ (posedge clock) begin 
  if (reset) 
  basePointer = 16'b0; 
  else if (write) 
  basePointer = writeData; 
  end 
  assign data = basePointer; 
 endmodule