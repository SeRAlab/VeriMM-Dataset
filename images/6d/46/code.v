module top_module(
	input [31:0] stage2_imm,
	input [31:0] stage2_rs2_data,
	input BSelSignal,
	output [31:0] stage2_alu_in2
);assign stage2_alu_in2 = (BSelSignal)? stage2_imm : stage2_rs2_data;

endmodule