module top_module(
	 input ALUSrc,              
	 input [31:0] ReadData2,    
	 input [31:0] imm32,        
	 output [31:0] ALU_B        
    );assign ALU_B = ALUSrc ? imm32 : ReadData2;endmodule