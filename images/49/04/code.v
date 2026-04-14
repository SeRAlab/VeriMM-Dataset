module top_module(IMM,SEXT);input [5:0] IMM;
	output [7:0] SEXT;
	
	assign SEXT={IMM[5], IMM[5], IMM[5:0]};

endmodule