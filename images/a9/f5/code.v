module top_module(
	input [1:0] aluOp,
	input [5:0] instructionCodeLowBits,
	input [5:0] instructionCodeHighBits,
	output reg [3:0] aluOperation
   );/*
		ALU Operation codes
			0: SLL
			1: SRL
			2: SRA
			3: ADD
			4: SUB
			5: AND
			6: OR
			7: XOR
			8: NOR
			9: SLT		
			
	  AluOp: 00 Store and Load
	  AluOp: 01 Branch Equal y Not Equal
	  AluOp: 10 Operaciones Tipo R
	  AluOp: 11 Operaciones con Immediate

	*/
	always @(*)begin
		case(aluOp)
		0: aluOperation<=3;
		1: aluOperation<=4;
		2: begin
			case(instructionCodeLowBits)
				6'b000000: aluOperation<=0; //SLL
				6'b000010: aluOperation<=1; //SRL
				6'b000011: aluOperation<=2; //SRA
				6'b000110: aluOperation<=1; //SRLV
				6'b000111: aluOperation<=2; //SRAV
				6'b000100: aluOperation<=0; //SLLV
				6'b100000: aluOperation<=3; //ADD
				6'b100010: aluOperation<=4; //SUB
				6'b100100: aluOperation<=5; //AND
				6'b100101: aluOperation<=6; //OR
				6'b100110: aluOperation<=7; //XOR
				6'b100111: aluOperation<=8; //NOR
				6'b101010: aluOperation<=9; //SLT
				default: aluOperation<='hF;
			endcase
		end
		3: begin
			case(instructionCodeHighBits)	
				6'b001000: aluOperation<=3; //ADDI
				6'b001100: aluOperation<=5; //ANDI
				6'b001101: aluOperation<=6; //ORI
				6'b001110: aluOperation<=7; //XORI
				6'b001010: aluOperation<=9; //SLTI
				default: aluOperation<='hF;
			endcase		
		end
		default:aluOperation<='hF;
	endcase
end
endmodule