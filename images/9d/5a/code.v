module top_module(
	input [31:0] instruction,
	output [5:0] op,
	output [4:0] rs,
	output [4:0] rt,
	output [4:0] rd,
	output [4:0] sa,
	output [5:0] funct,
	output [15:0] imm,
	output [25:0] jadr
);assign op = instruction[31:26];
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];
	assign sa = instruction[10:6];
	assign funct = instruction[5:0];
	assign imm = instruction[15:0];
	assign jadr = instruction[25:0];

endmodule