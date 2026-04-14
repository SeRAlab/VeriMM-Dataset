module top_module(
    input [31:0] ALUA,
    input [31:0] ALUB,
    input [2:0] ALUOp,
    output [31:0] ALU
    );parameter add_Op = 3'b001,
					sub_Op = 3'b010,
					orr_Op = 3'b011;
					
	reg[31:0] ALUOUT;				
	assign ALU = ALUOUT;
	
	always@ ( * ) begin
		case (ALUOp)
			add_Op:
				ALUOUT <= ALUA + ALUB;
			sub_Op:
				ALUOUT <= ALUA - ALUB;
			orr_Op:
				ALUOUT <= ALUA | ALUB;
			default:
				ALUOUT <= 32'h00000000;
		endcase
	end

endmodule