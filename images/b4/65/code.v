module top_module(
	input [31:0]Res_ALU,Fetch,target,
	input [31:0]Write_Data,
	input [31:0]contadorPc,
	input zero_flag,
	input[4:0]Write_Reg,
	input Branch,MemRead,MemtoReg,MemWrite,RegWrite,ControlJump,
	input clk,
	output reg Sal_zf,
	output reg[31:0]SRes_ALU, SFetch,Starget,
	output reg[31:0]SalWD, 
	output reg[4:0]Sal_WR,
	output reg SBranch,SMemRead,SMemtoReg,SMemWrite,SRegWrite,SControlJump,
	output reg[31:0]SContadorPc
);always @(posedge clk)
	begin
		SFetch = Fetch;
	   SRes_ALU = Res_ALU;
		Sal_zf = zero_flag;
		SalWD = Write_Data;
		Sal_WR = Write_Reg;
		
		SBranch = Branch;
		SMemRead = MemRead;
		SMemtoReg = MemtoReg;
		SMemWrite = MemWrite;
		SRegWrite = RegWrite;
		SControlJump = ControlJump;
		Starget = target;
		SContadorPc = contadorPc;
		
	end

endmodule