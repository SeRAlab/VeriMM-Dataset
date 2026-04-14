module top_module(
	input [3:0]ALUOP,
	input [31:0] Instr,
	input [31:0]A,
	input signed [31:0]A_Signed,
	input [31:0]B,
	input signed[31:0]B_Signed,
	output[31:0]C
    );parameter  ADD  = 4'b0000,
					ADDU = 4'b0001,
					SUB  = 4'b0010,
					SUBU = 4'b0011,
					SLL  = 4'b0100,
					SRL  = 4'b0101,
					AND  = 4'b0110,
					OR   = 4'b0111,
					XOR  = 4'b1000,
					LUI  = 4'b1001;
					

	assign C =  (ALUOP==ADD) ?		A_Signed + B_Signed:
					(ALUOP==ADDU)?		A + B:
					(ALUOP==SUB)?		A_Signed - B_Signed:
					(ALUOP==SUBU)?		A - B:
					(ALUOP==SLL)?		B << Instr[10:6]:
					(ALUOP==SRL)?		B >> Instr[10:6]:
					(ALUOP==AND)?		A & B:
					(ALUOP==OR)?		A | B:
					(ALUOP==XOR)?		A ^ B:
					(ALUOP==LUI)?		B:
					
					32'bx;
					
					
endmodule