module top_module(Rs, BranchOp, Branch, PCImm, Jump, PCSrc);input[1:0] BranchOp; 
	input[15:0] Rs;
	input Branch, PCImm, Jump;
	output PCSrc;
	
	wire take_branch, Zero, Neg;
	
	assign Zero = ~|Rs;
	assign Neg = Rs[15];
	assign take_branch = Branch?
								(BranchOp==2'b00)?~Zero:
								(BranchOp==2'b01)?Zero:
								(BranchOp==2'b10)?Neg:
								(BranchOp==2'b11)?~Neg:
								1'b0
						 :1'b0;
	assign PCSrc = PCImm | Jump | take_branch;
	
endmodule