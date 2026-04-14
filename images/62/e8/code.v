module top_module(
	input[31:0] instruction,
	output[5:0] opcode,
	output[4:0] Rs,
	output[4:0] Rt,
	output[15:0] imm
);assign opcode = instruction[31:26];
	assign Rs = instruction[25:21];
	assign Rt = instruction[20:16];
	assign imm = instruction[15:0];

endmodule