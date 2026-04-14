module top_module( CVALID, IOSEL, ADDR, TAG0, TAG1, CFG, WRITE, MMU_HIT, CI, INVAL_L, KDET, ENDRAM, DC_ILO,
				  CA_HIT, CA_SET, UPDATE, IO_SPACE, USE_CA, WB_ACC, KILL );input	[23:0]	CVALID;
	input	 [3:0]	IOSEL;
	input	[27:4]	ADDR;
	input  [27:12]	TAG0,TAG1;
	input	 [1:0]	CFG;	
	input			WRITE;
	input			MMU_HIT;
	input			CI;
	input			INVAL_L;	
	input			KDET;
	input			ENDRAM;
	input			DC_ILO;		
	
	output			CA_HIT;
	output			CA_SET;	
	output	[23:0]	UPDATE;	
	output			IO_SPACE;
	output			USE_CA;
	output			WB_ACC;
	output			KILL;
	
	reg		 [7:0]	maske;
	
	wire			match_0,match_1;
	wire			valid_0,valid_1;
	wire			select;
	wire			clear;
	wire	 [7:0]	update_0,update_1,lastinfo;
	wire			sel_dram;
	
	always @(ADDR)
		case (ADDR[6:4])
		  3'h0 : maske = 8'h01;
		  3'h1 : maske = 8'h02;
		  3'h2 : maske = 8'h04;
		  3'h3 : maske = 8'h08;
		  3'h4 : maske = 8'h10;
		  3'h5 : maske = 8'h20;
		  3'h6 : maske = 8'h40;
		  3'h7 : maske = 8'h80;
		endcase
		
	assign valid_0 = (( CVALID[7:0] & maske) != 8'h00);
	assign valid_1 = ((CVALID[15:8] & maske) != 8'h00);
	
	assign match_0 = ( TAG0 == ADDR[27:12] );	
	assign match_1 = ( TAG1 == ADDR[27:12] );	

	assign CA_HIT = ((valid_0 & match_0) | (valid_1 & match_1)) & ~DC_ILO & CFG[0];
	
	
	assign select = (valid_1 & valid_0) ? ~((CVALID[23:16] & maske) != 8'h00) : valid_0;	
	
	assign CA_SET = CA_HIT ? (valid_1 & match_1) : select;
	
	assign clear = INVAL_L | KDET;	
 
	assign update_0 = CA_SET ? CVALID[7:0] : (clear ? (CVALID[7:0] & ~maske) : (CVALID[7:0] | maske));
	assign update_1 = CA_SET ? (clear ? (CVALID[15:8] & ~maske) : (CVALID[15:8] | maske)) : CVALID[15:8];
	
	assign lastinfo = CA_HIT ? (CA_SET ? (CVALID[23:16] | maske) : (CVALID[23:16] & ~maske)) : CVALID[23:16];
	
	assign UPDATE = {lastinfo,update_1,update_0};
	
	assign KILL = clear & CA_HIT & ~CFG[1];		
	
	assign sel_dram = (IOSEL == 4'b0000) & ENDRAM;	
	assign IO_SPACE = ~sel_dram;					
	assign USE_CA   = ~CI & ~DC_ILO & CFG[0] & ~CFG[1];	
	assign WB_ACC   = WRITE & MMU_HIT & sel_dram;
	
endmodule