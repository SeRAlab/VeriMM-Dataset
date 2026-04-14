module aeMB_regf (
   rREGA, rREGB, rDWBDI, dwb_dat_o, fsl_dat_o,
   rOPC, rRA, rRB, rRW, rRD, rMXDST, rPCLNK, rRESULT, rDWBSEL, rBRA,
   rDLY, dwb_dat_i, fsl_dat_i, gclk, grst, gena
   );
   output [31:0] rREGA, rREGB;
   output [31:0] rDWBDI;
   input [5:0] 	 rOPC;   
   input [4:0] 	 rRA, rRB, rRW, rRD;
   input [1:0] 	 rMXDST;
   input [31:2]  rPCLNK;
   input [31:0]  rRESULT;
   input [3:0] 	 rDWBSEL;   
   input 	 rBRA, rDLY;   
   output [31:0] dwb_dat_o;   
   input [31:0]  dwb_dat_i;   
   output [31:0] fsl_dat_o;
   input [31:0]	 fsl_dat_i;   
   input 	 gclk, grst, gena;   
   wire [31:0] 	 wDWBDI = dwb_dat_i; 
   wire [31:0] 	 wFSLDI = fsl_dat_i; 
   reg [31:0] 	 rDWBDI;
   reg [1:0] 	 rSIZ;
   always @(rDWBSEL or wDWBDI or wFSLDI) begin
      case (rDWBSEL)
	4'h8: rDWBDI <= {24'd0, wDWBDI[31:24]};
	4'h4: rDWBDI <= {24'd0, wDWBDI[23:16]};
	4'h2: rDWBDI <= {24'd0, wDWBDI[15:8]};
	4'h1: rDWBDI <= {24'd0, wDWBDI[7:0]};
	4'hC: rDWBDI <= {16'd0, wDWBDI[31:16]};
	4'h3: rDWBDI <= {16'd0, wDWBDI[15:0]};
	4'hF: rDWBDI <= wDWBDI;
	4'h0: rDWBDI <= wFSLDI;       
	default: rDWBDI <= 32'hX;       
      endcase
   end
   always @(posedge gclk)
     if (grst) begin
	rSIZ <= 2'h0;
     end else if (gena) begin
	rSIZ <= rOPC[1:0];	
     end
   reg [31:0] 	 mARAM[0:31],
		 mBRAM[0:31],
		 mDRAM[0:31];
   wire [31:0] 	 rREGW = mDRAM[rRW];   
   wire [31:0] 	 rREGD = mDRAM[rRD];   
   assign 	 rREGA = mARAM[rRA];
   assign 	 rREGB = mBRAM[rRB];
   wire 	 fRDWE = |rRW;   
   reg [31:0] 	 xWDAT;
   always @(rDWBDI or rMXDST or rPCLNK or rREGW
	    or rRESULT)
     case (rMXDST)
       2'o2: xWDAT <= rDWBDI;
       2'o1: xWDAT <= {rPCLNK, 2'o0};
       2'o0: xWDAT <= rRESULT;       
       2'o3: xWDAT <= rREGW; 
     endcase 
   always @(posedge gclk)
     if (grst | fRDWE) begin
	mARAM[rRW] <= xWDAT;
	mBRAM[rRW] <= xWDAT;
	mDRAM[rRW] <= xWDAT;	
     end
   reg [31:0] 	 rDWBDO, xDWBDO;
   wire [31:0] 	 xFSL;   
   wire 	 fFFWD_M = (rRA == rRW) & (rMXDST == 2'o2) & fRDWE;
   wire 	 fFFWD_R = (rRA == rRW) & (rMXDST == 2'o0) & fRDWE;   
   assign 	 fsl_dat_o = rDWBDO;
   assign 	 xFSL = (fFFWD_M) ? rDWBDI :
			(fFFWD_R) ? rRESULT :
			rREGA;   
   wire [31:0] 	 xDST;   
   wire 	 fDFWD_M = (rRW == rRD) & (rMXDST == 2'o2) & fRDWE;
   wire 	 fDFWD_R = (rRW == rRD) & (rMXDST == 2'o0) & fRDWE;   
   assign 	 dwb_dat_o = rDWBDO;
   assign 	 xDST = (fDFWD_M) ? rDWBDI :
			(fDFWD_R) ? rRESULT :
			rREGD;   
   always @(rOPC or xDST or xFSL)
     case (rOPC[1:0])
       2'h0: xDWBDO <= {(4){xDST[7:0]}};
       2'h1: xDWBDO <= {(2){xDST[15:0]}};
       2'h2: xDWBDO <= xDST;
       2'h3: xDWBDO <= xFSL;       
     endcase 
   always @(posedge gclk)
     if (grst) begin
	rDWBDO <= 32'h0;
     end else if (gena) begin
	rDWBDO <= #1 xDWBDO;	
     end
   integer i;
   initial begin
      for (i=0; i<32; i=i+1) begin
	 mARAM[i] <= $random;
	 mBRAM[i] <= $random;
	 mDRAM[i] <= $random;
      end
   end
endmodule