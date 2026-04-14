module top_module(data, NPC, PC);input [15:0] data;
	input [7:0] NPC;
	output [7:0] PC;
	parameter Yes  = 3'b1;
	parameter No   = 3'b0;
	parameter BNE  = 5'b10011;
	parameter BE   = 5'b10100;
	parameter BNER = 5'b10101;
	parameter BER  = 5'b10110;
	parameter J    = 5'b10111;
	parameter JR   = 5'b11000;
	reg [7:0] M;
	reg [4:0] opcode;
	reg [2:0] R1, R2;
	reg [7:0] PC;
	always @ (data) 
		opcode <= data[15:11];
	always @ (data or opcode) 
		case(opcode)
			BNE: begin R1 <= data[10:8]; M <= data[7:0]; end
			BE: begin R1 <= data[10:8]; M <= data[7:0]; end
			BNER: begin	R1 <= data[10:8]; R2 <= data[2:0]; end
			BER: begin	R1 <= data[10:8]; R2 <= data[2:0]; end
			J: begin M <= data[7:0]; end
			JR: begin R1 <= data[2:0]; end
		endcase
	always @ (opcode or R1 or R2 or M) 
		case(opcode)
			BNE: PC <= (R1 != No) ? M : NPC;
			BE: PC <= (R1 == No) ?  M : NPC;
			BNER: PC <= (R1 != No) ? R2 : NPC;
			BER: PC <= (R1 == No) ? R2 : NPC;
			J: PC <= M;
			JR: PC <= R1;
			default: PC <= No;
		endcase
endmodule