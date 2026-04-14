module top_module(
	input  					CLK1,				
	input  					CLK0,				
	input 					NPURST,			
	input 					F17X,				
	input 					FCLK,				
	input 					F13X,				
	input 					INST,				
	input 					NRUN,				
	input 					SNI,				
	input 					OUT8,				
	input 					NSA,				
	input 					NSTEP,			
	output reg	[3:0]		TPG,				
	output					STBY				
);wire	TPG0 = !(!NPURST | !(F17X | !FCLK));	
wire	TPG1 = !(!F13X & FCLK);						
wire	TPG2 = !(!(INST & !SNI) & NRUN);			
wire	TPG3 = !(!SNI | !OUT8 | NSA);				
wire	TPG4 = NSTEP;									
wire	TPG5 = !(NSTEP & NRUN);						




wire	CNT_D1 = !(!NTP12 & TPG3);
wire	CNT_PE = !(!(!TPG3|NTP12) | !(NTP12|!TPG2|TPG3) | !(NWAIT|!TPG5));
wire	CNT_CET = !(!(NWAIT|TPG5) | (!(NSTBY|TPG0) | !(NPWRON|TPG1) | !(NSRLSE|TPG4)));




always @(posedge CLK1 or negedge NPURST) 
   if(!NPURST)       TPG <= 4'h0;						
	else if(!CNT_PE)  TPG <= {2'b00, CNT_D1, 1'b0};	
   else if(CNT_CET)  TPG  <= TPG + 4'd1;				












wire NSTBY	= !(TPG ==  0);
wire NPWRON = !(TPG ==  1);
wire NTP12  = !(TPG == 13);
wire NSRLSE = !(TPG == 14);
wire NWAIT  = !(TPG == 15);

assign STBY = NSTBY;


endmodule