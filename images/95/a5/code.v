module top_module(input clock, reset,input [1:0] op,input [15:0] writeData,output [15:0] data);reg [15:0] stackPointer; 
  always @ (posedge clock) begin 
  if (reset) 
  stackPointer = 16'b0; 
  else 
  case (op) 
  2'b00 : stackPointer = stackPointer + 1; 
  2'b01 : stackPointer = stackPointer - 1; 
  2'b10 : stackPointer = writeData; 
  2'b11 : stackPointer = stackPointer; 
  default : stackPointer = stackPointer; 
  endcase 
  end 
  assign data = stackPointer; 
 endmodule