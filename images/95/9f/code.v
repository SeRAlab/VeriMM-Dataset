module top_module(branchoffset, imm);output [31:0] branchoffset;
    input [29:0] imm;
	assign branchoffset[31:2] = imm[29:0]; 
	assign branchoffset[1:0] = 0;endmodule