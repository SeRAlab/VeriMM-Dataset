module top_module(BusImm, Imm32, Ctrl);output [63:0] BusImm; 
  input [31:0] Imm32; 
  input Ctrl; 

  wire extBit; 
  assign #1 extBit = (Ctrl ? 1'b0 : Imm32[31]); 
  assign BusImm = {{32{extBit}}, Imm32}; 

endmodule