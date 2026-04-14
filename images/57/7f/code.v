module top_module( clk, MemtoReg, RegWrite, RD, ALU_out, WN, MEM_WB_MemtoReg, MEM_WB_RegWrite, MEM_WB_RD, MEM_WB_ALU_out, MEM_WB_WN );input clk, MemtoReg, RegWrite;
	input [31:0] RD, ALU_out;
	input [4:0] WN;
	
	output MEM_WB_MemtoReg, MEM_WB_RegWrite;
	output [31:0] MEM_WB_RD, MEM_WB_ALU_out;	
	output [4:0] MEM_WB_WN;
	
	reg MEM_WB_MemtoReg, MEM_WB_RegWrite;
	reg [31:0] MEM_WB_RD, MEM_WB_ALU_out;
	reg [4:0] MEM_WB_WN;
	
	always @( posedge clk ) begin

		MEM_WB_ALU_out <= ALU_out;
		MEM_WB_MemtoReg <= MemtoReg;
		MEM_WB_RD <= RD;
		MEM_WB_RegWrite <= RegWrite;
		MEM_WB_WN <= WN;
		
	end
	
	
endmodule