module top_module(
    input [31:0] ALU_A,
    input [31:0] ALU_B,
    input [1:0] ALUOP,
	 input sltiu,
    output reg[31:0] ALU_C,
    output ALU_ZERO,G, L, G_E, L_E, NE,
	 output less
    );wire [31:0]sub;
	 assign ALU_ZERO = (ALU_A==ALU_B)?1:0;
	 assign sub = ALU_A - ALU_B;
	 assign G = (ALU_A == 0) ? 0 : ~ALU_A[31];
	 assign L = (ALU_A == 0) ? 0 : ALU_A[31];
	 assign G_E = ~ALU_A[31];
	 assign L_E = (ALU_A == 0) ? 1 : ALU_A[31];
	 assign NE = (ALU_A != ALU_B)?1:0;
	 assign less = sltiu ?  ALU_A < ALU_B : ALU_A[31]>ALU_B[31] ? 1 : (ALU_A[31]==ALU_B[31]) ? sub[31] : 0 ;
    always @(*)begin
		case (ALUOP)
		2'b00: ALU_C =ALU_A + ALU_B;
		2'b01: ALU_C =ALU_A - ALU_B;
		2'b10: ALU_C =ALU_A | ALU_B;
		default:ALU_C = 32'bx;
		endcase
	 end
endmodule