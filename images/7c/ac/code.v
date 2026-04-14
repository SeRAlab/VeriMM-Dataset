module top_module(opcode,Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0);input [10:0]opcode;


output reg Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0;


always@(opcode)
	begin
	casex(opcode)
			
			11'b1xx0101x000: 
			begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} <= 9'b000100010;
			end
			
			11'b11111000010: begin 
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} <= 9'b011110000;
              	  
			end
			
			11'b11111000000: begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} <= 9'b110001000;
				
			end
			
			11'b10110100xxx: begin
				{Reg2Loc,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp1,ALUOp0} <= 9'b100000101;
			end
		endcase
	end
endmodule