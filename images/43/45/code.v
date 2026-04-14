module top_module(
	input [31:0] instr,
	output branch, jump, MemToReg, MemWrite, RegDst, RegWrite, ALUSrc
);wire [5:0] opcode, func;
	assign opcode = instr[31:26];
	assign func = instr[5:0];
	wire add = ((opcode == 6'h00) & (func == 6'h20));
	wire sub = ((opcode == 6'h00) & (func == 6'h22));
	wire andd = ((opcode == 6'h00) & (func == 6'h24));
	wire orr = ((opcode == 6'h00) & (func == 6'h25));
	wire slt = ((opcode == 6'h00) & (func == 6'h2A));
	wire lw = (opcode == 6'h23);
	wire sw = (opcode == 6'h2B);
	wire beq = (opcode == 6'h04);
	wire addi = (opcode == 6'h08);
	wire jmp = (opcode == 6'h02);
	assign branch = beq;
	assign jump = jmp;
	assign MemToReg = lw;
	assign MemWrite = sw;
	assign RegDst = add | sub | andd | orr | slt;
	assign RegWrite = add | sub | andd | orr | slt | addi | lw;
	assign ALUSrc = addi | lw | sw;
endmodule