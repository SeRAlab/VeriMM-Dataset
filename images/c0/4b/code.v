module aeMB_bpcu (
   iwb_adr_o, rPC, rPCLNK, rBRA, rDLY,
   rMXALT, rOPC, rRD, rRA, rRESULT, rDWBDI, rREGA, gclk, grst, gena
   );
   parameter IW = 24;
   output [IW-1:2] iwb_adr_o;
   output [31:2]   rPC, rPCLNK;
   output 	   rBRA;
   output 	   rDLY;
   input [1:0] 	   rMXALT;   
   input [5:0] 	   rOPC;
   input [4:0] 	   rRD, rRA;  
   input [31:0]    rRESULT; 
   input [31:0]    rDWBDI; 
   input [31:0]    rREGA;
   input 	   gclk, grst, gena;
   wire 	   fRTD = (rOPC == 6'o55);
   wire 	   fBCC = (rOPC == 6'o47) | (rOPC == 6'o57);
   wire 	   fBRU = (rOPC == 6'o46) | (rOPC == 6'o56);
   wire [31:0] 	   wREGA;
   assign 	   wREGA = (rMXALT == 2'o2) ? rDWBDI :
			   (rMXALT == 2'o1) ? rRESULT :
			   rREGA;   
   wire 	   wBEQ = (wREGA == 32'd0);
   wire 	   wBNE = ~wBEQ;
   wire 	   wBLT = wREGA[31];
   wire 	   wBLE = wBLT | wBEQ;   
   wire 	   wBGE = ~wBLT;
   wire 	   wBGT = ~wBLE;   
   reg 		   xXCC;
   always @(rRD or wBEQ or wBGE or wBGT or wBLE or wBLT
	    or wBNE)
     case (rRD[2:0])
       3'o0: xXCC <= wBEQ;
       3'o1: xXCC <= wBNE;
       3'o2: xXCC <= wBLT;
       3'o3: xXCC <= wBLE;
       3'o4: xXCC <= wBGT;
       3'o5: xXCC <= wBGE;
       default: xXCC <= 1'bX;
     endcase 
   reg 		   rBRA, xBRA;
   reg 		   rDLY, xDLY;
   wire 	   fSKIP = rBRA & !rDLY;   
   always @(fBCC or fBRU or fRTD or rBRA or rRA or rRD
	    or xXCC)
     if (rBRA) begin
	xBRA <= 1'h0;
	xDLY <= 1'h0;
     end else begin
	xDLY <= (fBRU & rRA[4]) | (fBCC & rRD[4]) | fRTD;      
	xBRA <= (fRTD | fBRU) ? 1'b1 :
		(fBCC) ? xXCC :
		1'b0;
     end
   reg [31:2] 	   rIPC, xIPC;
   reg [31:2] 	   rPC, xPC;
   reg [31:2] 	   rPCLNK, xPCLNK;
   assign 	   iwb_adr_o = rIPC[IW-1:2];
   always @(rBRA or rIPC or rPC or rRESULT) begin
      xPCLNK <= rPC;
      xPC <= rIPC;
      xIPC <= (rBRA) ? rRESULT[31:2] : (rIPC + 1);
   end   			   
   wire 	wIMM = (rOPC == 6'o54) & !fSKIP;
   wire 	wRTD = (rOPC == 6'o55) & !fSKIP;
   wire 	wBCC = xXCC & ((rOPC == 6'o47) | (rOPC == 6'o57)) & !fSKIP;
   wire 	wBRU = ((rOPC == 6'o46) | (rOPC == 6'o56)) & !fSKIP;   
   wire 	fATOM = ~(wIMM | wRTD | wBCC | wBRU | rBRA);   
   reg [1:0] 	rATOM, xATOM;
   always @(fATOM or rATOM)
     xATOM <= {rATOM[0], (rATOM[0] ^ fATOM)};   
   always @(posedge gclk)
     if (grst) begin
	rATOM <= 2'h0;
	rBRA <= 1'h0;
	rDLY <= 1'h0;
	rIPC <= 30'h0;
	rPC <= 30'h0;
	rPCLNK <= 30'h0;
     end else if (gena) begin
	rIPC <= #1 xIPC;
	rBRA <= #1 xBRA;
	rPC <= #1 xPC;
	rPCLNK <= #1 xPCLNK;
	rDLY <= #1 xDLY;
	rATOM <= #1 xATOM;	
     end
endmodule