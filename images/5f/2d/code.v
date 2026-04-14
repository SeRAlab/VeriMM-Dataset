module top_module( CLK, RESET_N, RST_N, IO_WR, IO_RD, IO_A, IO_BE, IO_Q, IO_READY,
					   W_OUT_REG, IN_DAT, BOOT_DAT, STAT_DAT, ENDRAM );input			CLK;
input			RESET_N;
input			IO_WR,IO_RD;
input  [31:28]	IO_A;
input	 [3:0]	IO_BE;

input	[31:0]	BOOT_DAT;
input	 [7:0]	IN_DAT;
input	[31:0]	STAT_DAT;

output	reg	[31:0]	IO_Q;
output	reg		RST_N;
output	reg		ENDRAM;
output			IO_READY;
output			W_OUT_REG;

reg				rd_rdy;
reg		 [3:0]	init_cou;

	always @(posedge CLK) rd_rdy <= IO_RD & ~rd_rdy;
	
	assign IO_READY = IO_WR | rd_rdy;

	always @(IO_A or BOOT_DAT or IN_DAT or STAT_DAT)
	  casex({IO_A})
		4'b000x : IO_Q = BOOT_DAT;	
		4'b0010 : IO_Q = {24'd0,IN_DAT};
		4'b0011 : IO_Q = STAT_DAT;
		default : IO_Q = 32'hxxxxxxxx;
	  endcase
	
	assign W_OUT_REG = IO_WR & (IO_A == 4'h2) & IO_BE[0];
	
	

	always @(posedge CLK or negedge RESET_N)
		if (!RESET_N) init_cou <= 4'h0;
		  else init_cou <= init_cou + 4'h1;
		  
	always @(posedge CLK or negedge RESET_N)
		if (!RESET_N) RST_N <= 1'b0;
		  else
			if (init_cou == 4'hF) RST_N <= 1'b1;
			
	
	always @(posedge CLK) ENDRAM <= (ENDRAM | (IO_RD & (IO_A == 4'h1))) & RST_N;

endmodule