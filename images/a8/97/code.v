module top_module(OpCode, PCImm);input [4:0]	OpCode;
output		PCImm;

assign PCImm = ((OpCode == 5'b00100) | (OpCode == 5'b00110)) ? 1'b1 : 1'b0;

endmodule