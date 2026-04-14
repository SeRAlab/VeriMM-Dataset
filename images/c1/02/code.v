module aeMB_ibuf (
   rIMM, rRA, rRD, rRB, rALT, rOPC, rSIMM, xIREG, rSTALL, iwb_stb_o,
   rBRA, rMSR_IE, rMSR_BIP, iwb_dat_i, iwb_ack_i, sys_int_i, gclk,
   grst, gena, oena
   );
   output [15:0] rIMM;
   output [4:0]  rRA, rRD, rRB;
   output [10:0] rALT;
   output [5:0]  rOPC;
   output [31:0] rSIMM;
   output [31:0] xIREG;
   output 	 rSTALL;   
   input 	 rBRA;
   input 	 rMSR_IE;
   input 	 rMSR_BIP;   
   output 	 iwb_stb_o;
   input [31:0]  iwb_dat_i;
   input 	 iwb_ack_i;
   input 	 sys_int_i;   
   input 	 gclk, grst, gena, oena;
   reg [15:0] 	 rIMM;
   reg [4:0] 	 rRA, rRD;
   reg [5:0] 	 rOPC;
   wire [31:0] 	 wIDAT = iwb_dat_i;
   assign 	 {rRB, rALT} = rIMM;   
   assign 	iwb_stb_o = 1'b1;
   reg [31:0] 	rSIMM, xSIMM;
   reg 		rSTALL;   
   wire [31:0] 	wXCEOP = 32'hBA2D0008; 
   wire [31:0] 	wINTOP = 32'hB9CE0010; 
   wire [31:0] 	wBRKOP = 32'hBA0C0018; 
   wire [31:0] 	wBRAOP = 32'h88000000; 
   wire [31:0] 	wIREG = {rOPC, rRD, rRA, rRB, rALT};   
   reg [31:0] 	xIREG;
   reg 		rFINT;
   reg [1:0] 	rDINT;
   wire 	wSHOT = rDINT[0];	
   always @(posedge gclk)
     if (grst) begin
	rDINT <= 2'h0;
	rFINT <= 1'h0;
     end else begin
	if (rMSR_IE)
	  rDINT <= #1 
		   {rDINT[0], sys_int_i};
	rFINT <= #1 
		 (rFINT | wSHOT) & rMSR_IE;
     end
   wire 	fIMM = (rOPC == 6'o54);
   wire 	fRTD = (rOPC == 6'o55);
   wire 	fBRU = ((rOPC == 6'o46) | (rOPC == 6'o56));
   wire 	fBCC = ((rOPC == 6'o47) | (rOPC == 6'o57));   
   always @(fBCC or fBRU or fIMM or fRTD or rBRA or rFINT
	    or wBRAOP or wIDAT or wINTOP) begin
      xIREG <= (rBRA) ? wBRAOP : 
	       (!fIMM & rFINT & !fRTD & !fBRU & !fBCC) ? wINTOP :
	       wIDAT;
   end
   always @(fIMM or rBRA or rIMM or wIDAT or xIREG) begin
      xSIMM <= (!fIMM | rBRA) ? { {(16){xIREG[15]}}, xIREG[15:0]} :
	       {rIMM, wIDAT[15:0]};
   end   
   always @(posedge gclk)
     if (grst) begin
	rIMM <= 16'h0;
	rOPC <= 6'h0;
	rRA <= 5'h0;
	rRD <= 5'h0;
	rSIMM <= 32'h0;
     end else if (gena) begin
	{rOPC, rRD, rRA, rIMM} <= #1 xIREG;
	rSIMM <= #1 xSIMM;	
     end
   wire [5:0] wOPC = xIREG[31:26];   
   wire       fMUL = (wOPC == 6'o20) | (wOPC == 6'o30);
   wire       fBSF = (wOPC == 6'o21) | (wOPC == 6'o31);   
   always @(posedge gclk)
     if (grst) begin
	rSTALL <= 1'h0;
     end else begin
	rSTALL <= #1 (!rSTALL & (fMUL | fBSF)) | (oena & rSTALL);	
     end
endmodule