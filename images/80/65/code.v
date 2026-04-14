module top_module( BCLK, BRESET, NEW_PTB, PTB1, IVAR, WR_MRAM, VADR, VADR_R, MVALID, UPDATE,
				WE_MV, WADR_MV, RADR_MV, DAT_MV, NEW_PTB_RUN );input			BCLK;
	input			BRESET;	
	input			NEW_PTB;	
	input			PTB1;		
	input			IVAR;
	input			WR_MRAM;	
	input  [19:16]	VADR,VADR_R;	
	input	[31:0]	MVALID,UPDATE;
	
	output			WE_MV;		
	output	 [3:0]	WADR_MV,RADR_MV;
	output	[31:0]	DAT_MV;
	output			NEW_PTB_RUN;
	
	reg				neue_ptb,wr_flag,old_rst,run_over;
	reg		 [3:0]	count;
	
	wire	[15:0]	new_val;
	
	assign WE_MV   = wr_flag | WR_MRAM | IVAR;	
	assign RADR_MV = run_over ? count : VADR;
	assign WADR_MV = wr_flag ? (count - 4'b0001) : VADR_R;
	assign DAT_MV  = wr_flag ? {MVALID[31:16],new_val} : UPDATE;	

	
	assign new_val = neue_ptb ? (PTB1 ? (MVALID[15:0] & ~MVALID[31:16]) : (MVALID[15:0] & MVALID[31:16])) : 16'h0;
	
	always @(posedge BCLK or negedge BRESET)
		if (!BRESET) neue_ptb <= 1'b0;
			else neue_ptb <= NEW_PTB | (neue_ptb & run_over);
			
	always @(posedge BCLK) old_rst <= BRESET;	
	
	always @(posedge BCLK) run_over <= ((~old_rst | NEW_PTB) | (run_over & (count != 4'hF))) & BRESET;
	
	always @(posedge BCLK) count <= run_over ? count + 4'h1 : 4'h0;
	
	always @(posedge BCLK) wr_flag <= run_over;

	assign NEW_PTB_RUN = wr_flag;	
	
endmodule