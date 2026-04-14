module top_module( BCLK, BRESET, NEW, LOAD_PC, NEW_PC, NEXT_ADR, NEXT_PCA, DISP, PC_NEW, USED, USER, SAVE_PC, FPU_TRAP,
					  ADIVAR, PC_ARCHI, PC_ICACHE, PC_SAVE, ALSB, IC_USER);input			BCLK,BRESET;
	input			NEW;
	input			LOAD_PC;
	input			NEW_PC;
	input			NEXT_ADR;
	input			NEXT_PCA;
	input	[31:0]	DISP;
	input	[31:0]	PC_NEW;
	input	 [2:0]	USED;
	input			USER;
	input			SAVE_PC;
	input			FPU_TRAP;
	input			ADIVAR;
	
	output	[31:0]	PC_ARCHI;	
	output	[31:0]	PC_ICACHE;
	output	[31:0]	PC_SAVE;	
	output	 [1:0]	ALSB;
	output			IC_USER;
	
	reg		[31:0]	PC_ARCHI;
	reg		[31:0]	pc_adduse;
	reg		[31:0]	pc_ic_reg;
	reg		[31:0]	fpu_trap_pc;
	reg				IC_USER;
	
	wire	[31:0]	branch,pc_jump,next_pc,pc_icache_i;
	
	assign PC_SAVE = pc_adduse + {29'h0,USED};
	assign branch  = PC_ARCHI + DISP;
	
	assign pc_jump = LOAD_PC ? PC_NEW : branch;
	
	assign next_pc = NEW ? pc_jump : PC_SAVE;	
	
	always @(posedge BCLK or negedge BRESET)
		if (!BRESET) pc_adduse <= 32'h0;
		  else
			pc_adduse <= next_pc;
			
	
	
	always @(posedge BCLK)
		if (FPU_TRAP) PC_ARCHI <= fpu_trap_pc;	
		  else
			if (NEXT_PCA) PC_ARCHI <= pc_adduse;
	
	always @(posedge BCLK) if (SAVE_PC) fpu_trap_pc <= PC_ARCHI;	
	
	always @(posedge BCLK or negedge BRESET)
		if (!BRESET) pc_ic_reg <= 32'h0;
		  else
			pc_ic_reg <= pc_icache_i;
		
	
	
	assign pc_icache_i = NEW_PC ? (NEW ? pc_jump : pc_adduse) : (NEXT_ADR ? ({pc_ic_reg[31:2],2'b00} + 32'h0000_0004) : pc_ic_reg);
	
	
	assign PC_ICACHE = {(ADIVAR ? PC_NEW[31:4] : pc_icache_i[31:4]),pc_icache_i[3:0]};
	
	assign ALSB = pc_ic_reg[1:0];	
	
	
	always @(posedge BCLK or negedge BRESET)
		if (!BRESET) IC_USER <= 1'b0;
		  else
			if (NEW_PC) IC_USER <= USER;
	
endmodule