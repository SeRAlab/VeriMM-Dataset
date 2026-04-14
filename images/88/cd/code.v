module top_module(
		 input [20:0] Instruction_EX,
		 input RegDst_EX,
		 output [4:0] Write_Register_EX
		 );assign Write_Register_EX = RegDst_EX ? Instruction_EX[15:11] : Instruction_EX[20:16];

endmodule