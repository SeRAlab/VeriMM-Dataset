module top_module(
	input [5:0] ALUOp,
	input [5:0] funct,
	output wire [3:0] ALUcontrolOut
	);assign ALUcontrolOut = 	(ALUOp == 6'b000100) ? 4'b0001 : 
									(ALUOp == 6'b000101) ? 4'b0001 : 
									(ALUOp == 6'b001000) ? 4'b0000 : 
									(ALUOp == 6'b001010) ? 4'b0110 : 
									(ALUOp == 6'b001100) ? 4'b0010 : 
									(ALUOp == 6'b001101) ? 4'b0011 : 
									(ALUOp == 6'b001110) ? 4'b0100 : 
									(ALUOp == 6'b001111) ? 4'b1101 : 
									(ALUOp == 6'b100000) ? 4'b0000 : 
									(ALUOp == 6'b100001) ? 4'b0000 : 
									(ALUOp == 6'b100011) ? 4'b0000 : 
									(ALUOp == 6'b100100) ? 4'b0000 : 
									(ALUOp == 6'b100101) ? 4'b0000 : 
									(ALUOp == 6'b100111) ? 4'b0000 : 
									(ALUOp == 6'b101000) ? 4'b0000 : 
									(ALUOp == 6'b101001) ? 4'b0000 : 
									(ALUOp == 6'b101011) ? 4'b0000 : 
									(ALUOp == 6'b000011) ? 4'b0000 : 
									(	(funct == 6'b100000) ? 4'b0000 : 
										(funct == 6'b100010) ? 4'b0001 : 
										(funct == 6'b100100) ? 4'b0010 : 
										(funct == 6'b100101) ? 4'b0011 : 
										(funct == 6'b100110) ? 4'b0100 : 
										(funct == 6'b100111) ? 4'b0101 : 
										(funct == 6'b101010) ? 4'b0110 : 
										(funct == 6'b000000) ? 4'b0111 : 
										(funct == 6'b000010) ? 4'b1000 : 
										(funct == 6'b000011) ? 4'b1001 : 
										(funct == 6'b000100) ? 4'b1010 : 
										(funct == 6'b000110) ? 4'b1011 : 
										(funct == 6'b000111) ? 4'b1100 : 
										(funct == 6'b001001) ? 4'b0000 : 
										4'b1111); 
	
endmodule