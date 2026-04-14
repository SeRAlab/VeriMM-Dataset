module top_module( BCLK, READ, DACC_OK, DC_ACC, DPTE_ACC, DC_MDONE, DRAM_WR, IC_READ, IACC_OK, DATA_HOLD,
				   IC_ACC, IPTE_ACC, IC_MDONE, KOLLISION, STATSIGS );input	BCLK;
	input	READ,DACC_OK;
	input	DC_ACC,DPTE_ACC,DC_MDONE;
	input	DRAM_WR;
	input	IC_READ,IACC_OK,DATA_HOLD;
	input	IC_ACC,IPTE_ACC,IC_MDONE;
	input	KOLLISION;
	
	output	reg [7:0]	STATSIGS;

	always @(posedge BCLK)
		begin
			STATSIGS[7] <= KOLLISION;						
			STATSIGS[6] <= IPTE_ACC;						
			STATSIGS[5] <= IC_ACC & IC_MDONE;				
			STATSIGS[4] <= IC_READ & IACC_OK & ~DATA_HOLD;	
			STATSIGS[3] <= DRAM_WR;							
			STATSIGS[2] <= DPTE_ACC;						
			STATSIGS[1] <= DC_ACC & DC_MDONE;				
			STATSIGS[0] <= READ & DACC_OK;					
		end
		
endmodule