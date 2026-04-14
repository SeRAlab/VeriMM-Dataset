module top_module(opcode, branchLessResult, branchNotEqualResult, currentStatus, shouldBranch);input [4:0] opcode;
	input branchLessResult, branchNotEqualResult, currentStatus;
	output shouldBranch;
	
	wire branchBNE, branchBLT, branchX;
	assign branchBNE = branchNotEqualResult & ~opcode[4] & ~opcode[3] & ~opcode[2] & opcode[1] & ~opcode[0];
	
	assign branchBLT = branchLessResult & ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0];
	
	assign branchX = currentStatus & opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & ~opcode[0];
	
	
	assign shouldBranch = branchBNE | branchBLT | branchX;endmodule