module top_module(
	input[31:0] Instruction,

	output[15:0] imm,
	output[5:0] Op,
	output[4:0] Rs,
	output[4:0] Rt
);assign Op = Instruction[31:26];
	assign Rs = Instruction[25:21];
	assign Rt = Instruction[20:16];
	assign imm = Instruction[15:0];

endmodule