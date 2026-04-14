module aeMB2_iwbif (
   iwb_adr_o, iwb_stb_o, iwb_sel_o, iwb_wre_o, iwb_cyc_o, iwb_tag_o,
   ich_adr, fet_fb, rpc_if, rpc_ex, rpc_mx, exc_iwb,
   iwb_ack_i, iwb_dat_i, ich_hit, msr_ex, hzd_bpc, hzd_fwd, bra_ex,
   bpc_ex, gclk, grst, dena, iena, gpha
   );
   parameter AEMB_IWB = 32;
   parameter AEMB_HTX = 1;
   output [AEMB_IWB-1:2] iwb_adr_o;
   output 		 iwb_stb_o;
   output [3:0] 	 iwb_sel_o;
   output 		 iwb_wre_o;
   output 		 iwb_cyc_o;
   output 		 iwb_tag_o;   
   input 		 iwb_ack_i;
   input [31:0] 	 iwb_dat_i;
   output [AEMB_IWB-1:2] ich_adr;
   input 		 ich_hit;
   output 		 fet_fb;   
   output [31:2] 	 rpc_if,
			 rpc_ex,
			 rpc_mx;
   input [7:5] 		 msr_ex;   
   input 		 hzd_bpc,
			 hzd_fwd;
   input [1:0] 		 bra_ex;   
   input [31:2] 	 bpc_ex;
   output 		 exc_iwb;   
   input 		 gclk,
			 grst,
			 dena,
			 iena,
			 gpha;      
   reg			iwb_stb_o;
   reg [31:2]		rpc_if;
   reg [31:2]		rpc_mx;
   reg [31:2] 		rpc_of, 
			rpc_ex;
   reg [31:2] 		rADR, rADR_;
   wire [31:2] 		wPCINC = (rADR + 1); 
   wire [31:2] 		wPCNXT = rADR_;
   always @(posedge gclk)
     if (grst) begin
	rADR <= 30'h0;
	rADR_ <= 30'h0;
     end else if (iena) begin
	case ({hzd_fwd,bra_ex[1]})
	  2'o0: {rADR} <= #1 {rADR_[AEMB_IWB-1:2]}; 
	  2'o1: {rADR} <= #1 {bpc_ex[AEMB_IWB-1:2]}; 
	  2'o2: {rADR} <= #1 {rpc_if[AEMB_IWB-1:2]}; 
	  default: {rADR} <= #1 32'hX;	  
	endcase 
	rADR_ <= #1 wPCINC;	
     end 
   assign 		ich_adr = rADR;
   always @(posedge gclk)
     if (grst) begin
	rpc_ex <= 30'h0;
	rpc_if <= 30'h0;
	rpc_mx <= 30'h0;
	rpc_of <= 30'h0;
     end else begin
	if (dena) begin
	   {rpc_mx, 
	    rpc_ex, 
	    rpc_of} <= #1 {rpc_ex, 
			   rpc_of, 
			   rpc_if};		    
	end
	if (iena) begin
	   rpc_if <= #1 rADR;	   
	end
     end 
   always @(posedge gclk)
     if (grst) begin
	iwb_stb_o <= 1'h0;
     end else begin
	iwb_stb_o <= #1 (iwb_stb_o & !iwb_ack_i) | (!iwb_stb_o & !ich_hit);
     end
   assign 		iwb_adr_o = rADR;
   assign 		iwb_wre_o = 1'b0;
   assign 		iwb_sel_o = 4'hF;   
   assign 		iwb_cyc_o = iwb_stb_o;
   assign 		iwb_tag_o = msr_ex[5];   
   assign 		fet_fb = iwb_stb_o ~^ iwb_ack_i; 
   assign               exc_iwb = 1'b0;
endmodule