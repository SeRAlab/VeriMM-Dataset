module top_module(Instruction, extended_sign);input [15:0] Instruction;
	output [31:0] extended_sign;
	assign extended_sign=$signed(Instruction);

endmodule