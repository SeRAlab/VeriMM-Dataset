module top_module(
	clk,
	rst,
	con_alu,
	data,
	accum,
	opcode,
	zero,
	alu_out
);input clk, rst, con_alu;
input [7:0] data, accum;
input [2:0] opcode;
output reg[7:0]alu_out;
output reg zero;

parameter 
	HLT = 3'b000,
	SKZ = 3'b001,
	ADD = 3'b010,
	AND = 3'b011,
	XOR = 3'b100,
	LDA = 3'b101,
	STO = 3'b110,
	JMP = 3'b111
;



always@(posedge clk or negedge rst)begin
	if(!rst)alu_out <= 8'b0;
	else begin
		if(con_alu)begin
			casex(opcode)
				HLT: alu_out <= accum;
				SKZ: alu_out <= accum;
				ADD: alu_out <= accum + data;
				AND: alu_out <= accum & data;
				XOR: alu_out <= accum ^ data;
				LDA: alu_out <= data;
				STO: alu_out <= accum;
				JMP: alu_out <= accum;
				default:alu_out <= 8'hxx;
			endcase
		end
	end
end

always@(posedge clk or negedge rst)begin
	if(!rst) zero <= 1;
	else begin
		if(accum > 0) zero <= 0;
		else zero <= 1;
	end
end
	
endmodule