module top_module(branchPC, isBranchTaken,
		  branchTarget, op1, isRet, isUBranch, isBeq, flagsE, isBgt, flagsGT);input [31:0] branchTarget, op1;
   input 	isUBranch, isBeq, isBgt, flagsGT, flagsE, isRet;
   output [31:0] branchPC;
   output 	 isBranchTaken;
   assign branchPC = (isRet) ? op1 : branchTarget;
   assign isBranchTaken = isUBranch | (isBeq & flagsE) | (isBgt & flagsGT);
endmodule