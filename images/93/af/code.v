module top_module(input signed [15:0] SignImm,
					 input signed [15:0] PCPlus1,
					 output signed [15:0] PCBranch);assign PCBranch = SignImm + PCPlus1;

endmodule