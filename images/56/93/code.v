module top_module(
	input		[4-1:0]	instr,
	input		[2-1:0]	ALUOp,
	output wire	[4-1:0] ALU_Ctrl_o
	);wire instr30;
wire [2:0] funct3;

assign funct3 = {instr[2:0]};
assign instr30 = instr[3];

assign ALU_Ctrl_o = (funct3==3'b111)?4'b0000: 
					(funct3==3'b110)?4'b0001: 
					(funct3==3'b000 && ALUOp==2'b11)?4'b0010: 
					(funct3==3'b000 && ALUOp==2'b10 && instr30==1'b1)?4'b0110: 
					(funct3==3'b000 && (ALUOp==2'b10 || ALUOp==2'b11))?4'b0010: 
					(funct3==3'b100 && (ALUOp==2'b10 || ALUOp==2'b11))?4'b0011: 
					(funct3==3'b001 && (ALUOp==2'b10 || ALUOp==2'b11))?4'b0100: 
					(funct3==3'b101 && (ALUOp==2'b10 || ALUOp==2'b11))?4'b0101: 
					(funct3==3'b010 && (ALUOp==2'b10 || ALUOp==2'b11))?4'b0111: 
					(funct3==3'b010 && ALUOp==2'b00)?4'b0010: 
					4'b0110; 

endmodule