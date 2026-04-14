module top_module(OpCode, DMemWrite);input [4:0]	OpCode;
output		DMemWrite;

assign DMemWrite = ((OpCode == 5'b10000) | (OpCode == 5'b10011)) ? 1'b1 : 1'b0;

endmodule