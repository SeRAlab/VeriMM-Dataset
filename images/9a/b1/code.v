module top_module(input [31:0] ins, output [63:0] imm_data, output [11:0] imm_data12);wire [6:0] opcode;
	assign opcode = ins[6:0];
	wire [63:0] imm1, imm2, imm3;
	wire [11:0] im1, im2, im3;
	wire i, i2, s, b;
	assign i = &(~(opcode ^ 7'b0000011));
	assign i2 = &(~(opcode ^ 7'b0010011));
	assign s = &(~(opcode ^ 7'b0100011));
	assign b = &(~(opcode ^ 7'b1100011));
	
	assign imm1 = ({64{i}} & {52'b0, ins[31:20]});
	assign imm2 = imm1 | ({64{i2}} & {52'b0, ins[31:20]});
	assign imm3 = imm2 | ({64{s}} & {52'b0, ins[31:25], ins[11:7]});
	assign imm_data = imm3 | ({64{b}} & {52'b0, ins[31], ins[7], ins[30:25], ins[11:8] });

	assign im1 = {12{i}} & ins[31:20];
	assign im2 = im1 | {12{i2}} & ins[31:20];
	assign im3 = im2 | ({12{s}} & { ins[31:25], ins[11:7] });
	assign imm_data12 = im3 | ({12{b}} & { ins[31], ins[7], ins[30:25], ins[11:8] });

	
endmodule