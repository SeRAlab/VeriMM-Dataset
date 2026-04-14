module top_module(opcode,funct,immFlag, opCodeOutputThing);input [5:0] opcode; 
  input [5:0] funct; 
  output [11:0] opCodeOutputThing; 
  assign opCodeOutputThing= {opcode,funct}; 
  output immFlag; 
  assign immFlag = opcode? 1'b1 : 1'b0; 
 endmodule