module top_module(

	input					[5:0]		Inst,
	input									Compare,
	input					[5:0]		Fn,


	output	wire	[1:0]		RegDst,
	output	wire					ALUSrc,
	output	wire	[1:0]		MemtoReg,
	output	wire					RegWrite,
	output	wire					MemRead,
	output	wire					MemWrite,
	output	wire					Branch,
	output	wire	[1:0]		ALUOp,
	output	wire					Jump,
	output	wire					Jr,
	output	wire					FlushIF
    );wire							RFormat;
	wire							lw;
	wire							sw;
	wire							beq;
	wire							j;
	wire							addi;
	wire							subi;
	wire							jr0;


	assign						RFormat  =	&(~Inst[5:0]);
	assign						lw		   =	(&(~Inst[4:2])) & (&(Inst[1:0])) & Inst[5];
	assign						sw		   =	(&(Inst[1:0])) & Inst[5] & Inst[3] & ~Inst[4] & ~Inst[2];
	assign						beq	 		 =	(&(~Inst[5:3])) & (&(~Inst[1:0])) & Inst[2];
	assign						j				 =	(&(~Inst[5:2])) & Inst[1];												
	assign						addi		 =	(&(~Inst[5:4])) & Inst[3] & (&(~Inst[2:0]));			
	assign						subi		 =	(&(~Inst[5:3])) & Inst[2:0];											
	assign						jr0			 =	RFormat & (&(~Fn[5:4])) & Fn[3] & (&(~Fn[2:0]));  


	assign						RegDst[0]		=		RFormat ;
	assign						RegDst[1]		=		( j & Inst[0] );
	assign						ALUSrc			=		lw | sw | addi | subi;
	assign						MemtoReg[0]	=		lw;
	assign						MemtoReg[1]	=		( j & Inst[0] );
	assign						RegWrite		=		( RFormat | lw | ( j & Inst[0] ) | addi | subi ) & (~jr0);
	assign						MemRead			=		lw;
	assign						MemWrite		=		sw;
	assign						Branch			=		beq;
	assign						Jump				=		j;
	assign						Jr					=		jr0;
	assign						ALUOp[0]		=		beq | subi;
	assign						ALUOp[1]		=		RFormat;
	assign						FlushIF			=		( (Compare && beq) | j | jr0 ) ? 1'b1 : 1'b0;

endmodule