module top_module(input [3:0] opcode, output [2:0] ALUControl, output RegWrite, output RegDst, output ALUSrc, output Branch, output MemWrite, output MemtoReg);reg [8:0] combin;
	assign {RegWrite, RegDst, ALUSrc, ALUControl, Branch, MemWrite, MemtoReg} = combin;
	
	always @ (opcode)
	begin
		case (opcode)
			4'b0000: combin = 9'b0_0000_0000;   //NOP
			4'b0001: combin = 9'b1_1000_1000;   //ADD
			4'b0010: combin = 9'b1_1001_0000;   //SUB
			4'b0011: combin = 9'b1_1001_1000;   //AND
			4'b0100: combin = 9'b1_1001_0100;   //OR
			4'b0101: combin = 9'b1_0110_1000;   //LFT SHift
			4'b0110: combin = 9'b1_0111_0000;   //RT Shift
			4'b0111: combin = 9'b1_0100_1000;   //ADDI
			4'b1000: combin = 9'b1_0101_0000;   //SUBI
			4'b1001: combin = 9'b1_0100_1001;   //LD REG
			4'b1010: combin = 9'b0_0100_1010;   //Store Reg
			4'b1011: combin = 9'b1_0100_1001;   //LD I
			4'b1100: combin = 9'b0_0100_1010;   //Store I
			4'b1101: combin = 9'b0_0001_0100;   //Jump
			default: combin = 9'b0_0000_0000;   //NOP
		endcase
	end
	
endmodule