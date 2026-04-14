module aeMB2_brcc (
   bra_ex,
   opd_of, ra_of, rd_of, opc_of, gclk, grst, dena, iena, gpha
   );
   parameter AEMB_HTX = 1;   
   input [31:0] opd_of;   
   input [4:0] 	ra_of;
   input [4:0] 	rd_of;
   input [5:0] 	opc_of;   
   output [1:0] bra_ex;
   input 	gclk,
		grst,
		dena,
		iena,
		gpha;      
   reg [1:0]		bra_ex;
   wire 	wRTD = (opc_of == 6'o55);
   wire 	wBCC = (opc_of == 6'o47) | (opc_of == 6'o57);
   wire 	wBRU = (opc_of == 6'o46) | (opc_of == 6'o56);
   wire 	wBEQ = (opd_of == 32'd0);
   wire 	wBLT = opd_of[31];
   wire 	wBLE = wBLT | wBEQ;   
   wire 	wBNE = ~wBEQ;
   wire 	wBGE = ~wBLT;
   wire 	wBGT = ~wBLE;   
   reg 		 xcc;
   always @(rd_of or wBEQ or wBGE or wBGT or wBLE or wBLT
	    or wBNE) begin
      case (rd_of[2:0])
	3'o0: xcc <= wBEQ;
	3'o1: xcc <= wBNE;
	3'o2: xcc <= wBLT;
	3'o3: xcc <= wBLE;
	3'o4: xcc <= wBGT;
	3'o5: xcc <= wBGE;
	default: xcc <= 1'bX;
      endcase 
   end 
   always @(posedge gclk)
     if (grst) begin
	bra_ex <= 2'h0;
     end else if (dena) begin
	bra_ex[1] <= #1 (wRTD | wBRU | (wBCC & xcc)); 
	bra_ex[0] <= #1 (wBRU) ? ra_of[4] : rd_of[4]; 
     end
endmodule