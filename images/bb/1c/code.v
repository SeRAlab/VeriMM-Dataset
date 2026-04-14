module top_module(
	input [31:0] stage1_pc,
	input [31:0] stage1_imm,
	input [31:0] rs1_data,
	input [1:0] PCAddSelect,

	output reg [31:0] stage1_pc4
);always @(*) begin
	case (PCAddSelect)
		2'b01: stage1_pc4 = stage1_pc + stage1_imm;
		2'b10: stage1_pc4 = stage1_imm + rs1_data;
		default: stage1_pc4 = stage1_pc + 32'd4;
	endcase
end

endmodule